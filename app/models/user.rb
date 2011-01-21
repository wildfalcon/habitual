require 'net/https'

class User < ActiveRecord::Base

    scope :active, lambda { where("updated_at > ?", Time.now - 2.weeks)  }
    scope :inactive, lambda { where("updated_at <= ?", Time.now - 2.weeks)  }
  
    has_many :habits, :dependent => :destroy
  
    serialize :friend_ids, Array
  
    def profile_url(size = "square")
      "https://graph.facebook.com/#{uid}/picture?type=square"
    end
    
    def lifetime_in_days
      return ((updated_at - created_at)/60/60/24).to_i
    end

    def friends
      User.where(:uid =>  friend_ids)
    end
    
    def friends_with_habits
      # A beer to anyone who can do this in SQL that works in both Mysql and Postgres
      friends.includes(:habits).select{|u| u.habits.uncompleted.nonsecret.count > 0}
    end

    def subscribe_to_mailchimp!     
      unless self.sent_to_mailchimp?
        gb = Gibbon::API.new(ENV["MAILCHIMP_API_KEY"])

        lists = gb.lists({:start => 0, :limit=> 100})    
        list_id = lists["data"].detect{|l| l['name']=="HabitualApp List"}['id']

        
        first, last = nil, nil
        first, last = name.split if name.present?

        ret = gb.list_subscribe(:id => list_id, 
                                :email_address => email, 
                                :merge_vars => {:FNAME => first, :LNAME => last})

        if ret == "true"
          self.sent_to_mailchimp = true 
        else
          puts "got a return of #{ret}"
        end
        self.save!
      end
    end

    def post_to_facebook(message)
      if Rails.env == "production"
        url = URI.parse("https://graph.facebook.com/#{uid}/feed")
        request = Net::HTTP::Post.new(url.path)
        request.set_form_data({'access_token'=>self.access_token, 
          'message'=> message,
          'link' => "http://habitualapp.com",
          'caption' => "Making Habits that Stick",
          'name' => "HabitualApp"
          })

          http_session = Net::HTTP.new(url.host, url.port)
          http_session.use_ssl = true

          res = http_session.start {|http| http.request(request) }
          puts res.body
        elsif Rails.env == "test"
        else
          puts "Would have posted '#{message}' to facebook if I was running in production"
        end
      end

    def pull_profile_from_facebook
      uri = URI.parse(URI.escape("https://graph.facebook.com/#{uid}?access_token=#{access_token}"))
      puts uri.request_uri

      http_session = Net::HTTP.new(uri.host, uri.port)
      http_session.use_ssl = true
      res = http_session.start { |http|
        http.get(uri.request_uri)
      }
      self.attributes = JSON.parse(res.body).slice("name", "email")
      self.save!
    end
    
    def pull_friend_ids_from_facebook
      uri = URI.parse(URI.escape("https://graph.facebook.com/#{uid}/friends?access_token=#{access_token}"))
      puts uri.request_uri 

      http_session = Net::HTTP.new(uri.host, uri.port)
      http_session.use_ssl = true
      res = http_session.start { |http|
        http.get(uri.request_uri)
      }
      
      hash = JSON.parse(res.body);
      if hash.present? && hash["data"].present?
        self.friend_ids = hash["data"].inject([]){|a, v| a << v["id"]; a}
      end
    end
end
