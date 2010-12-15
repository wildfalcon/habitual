module ApplicationHelper

  def user_logged_in?
    fb_info_signed?
  end

  def current_user
    @current_user ||= begin
      return nil unless fb_info && fb_info['uid']
      user = User.find_by_uid(fb_info["uid"])
      user = User.create!(fb_info.slice("uid", "access_token")) if user.nil?
      user.access_token = fb_info["access_token"]
      user.save
      user
    end
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
