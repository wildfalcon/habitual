class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :user_logged_in?, :current_user

  def user_logged_in?
    fb_info_signed?
  end

  def current_user
    @current_user ||= begin
      return nil unless fb_info && fb_info['uid']
      user = User.find_by_uid(fb_info["uid"])
      if user.nil?
        user = User.create!(fb_info.slice("uid", "access_token")) 
        user.pull_profile_from_facebook
        user.pull_friend_ids_from_facebook
        user.save
      end
      
      
      unless user.access_token == fb_info["access_token"]
        # access token has changed, time to refresh FB info
        user.access_token = fb_info["access_token"]
        user.pull_profile_from_facebook
        user.pull_friend_ids_from_facebook
        user.save
      else
        puts "Access token not changed"
      end
      user
    end
  end

  def do403
    # render :file => "#{Rails.root}/public/404.html", :status => 404
    render :nothing => true, :status => 403
    return
  end

  private
  def fb_info
    cookie = request.cookies["fbs_#{ENV['FB_APP_ID']}"]

    return nil if cookie.blank?

    cookie[1..-2].split('&').reduce({}) do |hash, val|
      key, val = val.split('=')
      hash[key] = val
      hash
    end
  end

  def fb_info_signed?
    return false if fb_info.nil?
    unhashed_sig = fb_info.keys.reject{|k| k=="sig"}.sort.reduce(""){|out,k| "#{out}#{k}=#{fb_info[k]}"}.to_s + ENV["FB_APP_SECRET"]

    hashed_sig = Digest::MD5.hexdigest(unhashed_sig)
    hashed_sig == fb_info["sig"]
  end

end
