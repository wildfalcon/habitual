namespace :mailchimp do
  desc "Push all unpushed email addresses from habitaul to mailchimp"
  task :to_mailchimp  => :environment do
    User.all.each do |user|
      user.subscribe_to_mailchimp!
    end
  end
end