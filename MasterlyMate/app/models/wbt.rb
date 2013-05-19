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

# This class represents one wbt with the attributes name, description, 
# file (name of the uploaded wbt file), mainfile (path to the main entry file of this wbt) and difficulty level.
# Also this class contains many exams, many topics and belongs to many topics and belongs to a rank.
# The name, file, rank and difficulty shall be mandatory fields. Furthermore the name shall be unique.
# It derived from the base class ActiveRecord::Base.
# Therefore an instance of this class provides all CRUD (create, read, update and delete) operations.
class Wbt < ActiveRecord::Base
  has_and_belongs_to_many :topics
  has_many :exams
  belongs_to :rank
  attr_accessible :description, :name, :file, :mainFile, :topic_ids, :rank_id, :difficulty
  validates :name, :file, :rank_id, :difficulty, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  
  # Returns the number of points for the difficulty level of this wbt.
  def getDifficultyPoints
    points = 0
    if self.difficulty == "difficulty.easy"
      points = 25
    elsif self.difficulty == "difficulty.medium"
      points = 50
    elsif self.difficulty == "difficulty.difficult"
      points = 100
    end
    points
  end
  
end