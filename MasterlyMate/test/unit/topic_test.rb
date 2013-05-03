require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  topic = Topic.new()
  test "Add Topics" do
    i = 0
    while i<4 do
     topic.addTopic(Topic.new("TopicNr"+i))
      i += 1
    end
    i = 0
    topic.getAllTopics().each do
      i += 1
    end
    if i == 4 do
    assert true
    end
  end
  
  
  test "Search Topics" do
    testTopic = topic.searchTopicByName("TopicNr2")
    if testTopic.getNameOfTopic() == "TopicNr2" do
     assert true
    end
  end
  
  test "Delete Topics" do
    topic.deleteTopic("TopicNr3")
    test = topic.search("TopicNr3")
    if test == -1 do
      assert true
    end
  end
end
