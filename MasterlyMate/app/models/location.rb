class Location < ActiveRecord::Base
  attr_accessible :city, :state, :zipCode
end
