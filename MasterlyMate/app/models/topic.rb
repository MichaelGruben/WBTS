class Topic < ActiveRecord::Base
  attr_accessible :name, :childTopics
  
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
      if childTopics[i].name == nameOfSearchedTopic do
        return topic
      end
      i += 1
    end
    return -1
  end
  
  def deleteTopic(nameDeleteTopic)
    i = 0
    while i < childTopics.length do
      if childTopics[i].name == nameDeleteTopic do
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
  
end
