require 'net/https'

class User < ActiveRecord::Base
  
    has_many :habits, :dependent => :destroy
  
    serialize :friend_ids, Array
  
    # after_create :pull_profile_from_facebook
    # after_create :pull_friend_ids_from_facebook

    def profile_url(size = "square")
      "https://graph.facebook.com/#{uid}/picture?type=square"
    end

    def friends
      User.where(:uid =>  friend_ids)
    end
    
    def friends_with_habits
      # A beer to anyone who can do this in SQL that works in both Mysql and Postgres
      friends.includes(:habits).select{|u| u.habits.uncompleted.count > 0}
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
