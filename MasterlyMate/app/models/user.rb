class User < ActiveRecord::Base
  has_secure_password
  
  attr_accessible :birthdate, :email, :firstName, :lastName, :password, :password_confirmation, :username, :sex
  validates :username, :email, presence: true
  validates :username, uniqueness: { case_sensitive: false }
  validates :email, format: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, uniqueness: true
  
  def self.find_by_username_none_case_sensitive(username)
    where("lower(username) = ?", username.downcase).first
  end
  
end
