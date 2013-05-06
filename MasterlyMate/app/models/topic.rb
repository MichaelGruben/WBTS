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

class Topic < ActiveRecord::Base
  attr_accessible :name, :parent_name
=begin    
  def initialize(name)
    @name = name
    childTopics = Array.new(0)
  end
  
 #Methods 
  def addTopic(topic)
    childTopics[childTopics.length] = topic
  end
  
  def searchTopicByName(nameOfSearchedTopic)
    i = 0
    while i < childTopics.length do
      if childTopics[i].name == nameOfSearchedTopic
        return topic
      end
      i += 1
    end
    return -1
  end  
 
  def deleteTopic(nameDeleteTopic)
    i = 0
    while i < childTopics.length do
      if childTopics[i].name == nameDeleteTopic
        j = 0
        while j < i do
          tempArray1[j] = childTopics[j]
          j += 1
        end
        j = childTopics.length - 1
        while j > i do
          tempArray2[j] = childTopics[j]
          j -= 1
        end
        childTopics = tempArray1 + tempArray2
      end
        
      end
    end
           
  def getAllTopics()
    return childTopics
  end
=end      
end