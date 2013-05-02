class Course < ActiveRecord::Base
  attr_accessible :description, :name, :pathToFile, :mainFile
end
