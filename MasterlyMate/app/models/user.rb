class User < ActiveRecord::Base
  has_secure_password
  
  attr_accessible :birthdate, :email, :firstName, :lastName, :password, :password_confirmation, :username
  validates :username, :email, presence: true
  validates :username, uniqueness: true
end
