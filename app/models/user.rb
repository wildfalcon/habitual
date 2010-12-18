require 'net/https'

class User < ActiveRecord::Base
  
    has_many :habits
  
    after_create :pull_profile_from_facebook

    def profile_url(size = "square")
      "https://graph.facebook.com/#{uid}/picture?type=square"
    end

    private

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
end
