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

# This is the base helper, which provides useful methods for general purposes.
module ApplicationHelper
  
  # This method is validating the given model instance.
  # All errors thrown by the model instance, will be displayed in 
  # an unordered list. Therefore this method will return html content.
  def validateFieldsOf(model)
    returnValue = ""
    if model.errors.any?
      returnValue += "<ul class=\"validation_hint\">"
        model.errors.full_messages.each do |message|
          returnValue += "<li>#{message}</li>"
        end
      returnValue += "</ul>"
    end
    returnValue.html_safe
  end
  
  # This method invokes the csrf_meta_tags method, 
  # which will provide security against XSS and XSRF attacks.
  def ensureSecurity()
    csrf_meta_tags
  end
  
  # A comma separated string list will be returned by this method.
  # The selected attribute value of each element of the collection
  # will be embedded into the string list
  def getCommaSeparatedStringListOf(collection, attribute)
    result = ""
    elementCounter = 0
    collection.each do |element|
      result += element.send("#{attribute}")
      if elementCounter < collection.count - 1
        result += ","
      end
      elementCounter += 1
    end
    result
  end
  
  # This method is used to check if a string value contains 
  # the pattern t#. If so, the value after t# will be translated 
  # using the static t method of the I18n class.
  # The translated value of the given language string will then be
  # returned by this method.
  def shouldTransferRecordValue(value)
    translate = false
    if value.include? "t#"
      value = value.gsub("t#", "")
      translate = true
    end
    translate
  end
  
end
