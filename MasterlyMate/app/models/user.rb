#########################################################################
#Copyright 2013 Michael Gruben, Julian Babics, Benjamin Merkle
#
#This file is part of Masterly Mate.
#
#Masterly Mate is free software: you can redistribute it and/or modify it
#under the terms of the GNU Affero General Public License as published by
#the Free Software Foundation, either version 3 of the License, or (at
#your option) any later version.
#
#Masterly Mate is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU Affero General Public License for more details.
#
#You should have received a copy of the GNU Affero General Public License
#along with Masterly Mate.  If not, see <http://www.gnu.org/licenses/>.
#
#Diese Datei ist Teil von Masterly Mate.
#
#Masterly Mate ist Freie Software: Sie können es unter den Bedingungen
#der GNU Affero General Public License, wie von der Free Software
#Foundation, Version 3 der Lizenz oder (nach Ihrer Option) jeder späteren
#veröffentlichten Version, weiterverbreiten und/oder modifizieren.
#
#Masterly Mate wird in der Hoffnung, dass es nützlich sein wird, aber
#OHNE JEDE GEWÄHELEISTUNG, bereitgestellt; sogar ohne die implizite
#Gewährleistung der MARKTFÄHIGKEIT oder EIGNUNG FÜR EINEN BESTIMMTEN
#ZWECK.
#Siehe die GNU Affero General Public License für weitere Details.
#
#Sie sollten eine Kopie der GNU Affero General Public License zusammen
#mit Masterly Mate erhalten haben. Wenn nicht, siehe
#<http://www.gnu.org/licenses/>.
#########################################################################

# This class represents one user with the attributes birthdate, email, firstname, 
# lastname, password, username, sex, city, state and zipcode.
# Also this class contains many assessments, many groups and belongs to many groups.
# The username, email and password shall be mandatory fields. Furthermore the username and email shall be unique.
# It derived from the base class ActiveRecord::Base.
# Therefore an instance of this class provides all CRUD (create, read, update and delete) operations.
class User < ActiveRecord::Base
  has_secure_password
  has_and_belongs_to_many :groups
  has_many :assessments
  attr_accessible :birthdate, :email, :firstName, :lastName, :password, :password_confirmation, :username, :sex, :city, :state, :zipCode
  validates :username, :email, presence: true
  validates :username, uniqueness: { case_sensitive: false }
  validates :email, format: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, uniqueness: true
  
  # This method return the user specified by the given none case sensitive username
  def self.find_by_username_none_case_sensitive(username)
    where("lower(username) = ?", username.downcase).first
  end
  
  # This method checks if this user is a member of the given group
  def group?(group)
    return !!self.groups.find_by_name(group.to_s.camelize)
  end
  
  # Returns the whole number of reached points for the users assessments
  def reached_points?
    points = 0
    if self.assessments.count > 0
      points = self.assessments.sum("points")
    end
    points
  end
  
  # Returns the max number of possible points for this user
  def available_points?
    points = 0
    self.assessments.each do |assessment|
      assessment.topic.wbts.each do |wbt|
        points += wbt.getDifficultyPoints
      end
    end
    (points > 0) ? points : 1
  end
  
  # Returns the number of assessment, in which this user has the rank novice.
  def novice_count
    rank_count(1)
  end
  
  # Returns the number of assessment, in which this user has the rank competence.
  def competence_count
    rank_count(2)
  end
  
  # Returns the number of assessment, in which this user has the rank proficiency.
  def proficiency_count
    rank_count(3)
  end
  
  # Returns the number of assessment, in which this user has the rank expertise.
  def expertise_count
    rank_count(4)
  end
  
  # Returns the number of assessment, in which this user has the rank mastery.
  def mastery_count
    rank_count(5)
  end
  
  # This method will return the translated name of this users average rank according to the users proceeded assessments.
  def average_rank?
    average_rank = "-"
    assessmentCount = (self.assessments.count > 0) ? self.assessments.count : 1
    relativeValues = { "rank.novice" => (novice_count / assessmentCount.to_f) * 100,
      "rank.competence" => (competence_count / assessmentCount.to_f) * 100,
      "rank.proficiency" => (proficiency_count / assessmentCount.to_f) * 100,
      "rank.expertise" => (expertise_count / assessmentCount.to_f) * 100,
       "rank.mastery" => (mastery_count / assessmentCount.to_f) * 100
    }
    frequentRank = relativeValues.map{ |k,v| v==relativeValues.values.max ? k.to_s : nil }.compact.first
    average_rank = I18n.t(frequentRank)
    average_rank
  end
  
  # This method returns a list of the main topics for this user according to the users proceeded assessments.
  def user_main_topics_by_rank(rank)
    mainTopics = []
    self.assessments.select("distinct(topic_id)")
    mainTopics
  end
  
  private
  def rank_count(id)
    self.assessments.where("rank_id = ?", id).count
  end
  
end