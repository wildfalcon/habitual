class User < ActiveRecord::Base
  devise :omniauthable
  
  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me
end
