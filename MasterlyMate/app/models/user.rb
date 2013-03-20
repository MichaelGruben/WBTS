class User < ActiveRecord::Base
  attr_accessible :Birthdate, :email, :firstName, :lastName, :password, :username
end
