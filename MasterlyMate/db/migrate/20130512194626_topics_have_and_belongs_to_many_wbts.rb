class TopicsHaveAndBelongsToManyWbts < ActiveRecord::Migration
  def up
    create_table :topics_wbts, id: false do |t|
      t.references :topic, :wbt
    end
  end

  def down
    drop_table :topics_wbts
  end
end