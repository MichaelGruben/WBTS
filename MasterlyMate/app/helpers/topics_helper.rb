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

# This module is responsible for all useful methods depending on topic purposes.
module TopicsHelper
  
  # This method will generate and return an unordered html checkbox list.
  # This list will represent a topic hierarchy including indenting.
  def generate_TopicHierarchy(mainTopic, wbt)
    outHtml = "<ul class=\"withoutStyleType\">"
    mainTopic.topics.each do |topic|
          outHtml += "<li><label>#{check_box_tag :topic_ids, topic.id, wbt.topics.include?(topic), :name => 'wbt[topic_ids][]'}<u>#{topic.name}</u></label></li>"
          if topic.topics.count > 0
            outHtml += generate_TopicHierarchy(topic, wbt)
          end
    end
    outHtml += "</ul>"
    outHtml.html_safe
  end
  
end