class CreateAssessments < ActiveRecord::Migration
  def up
    create_table :assessments do |t|
      t.integer :points
      t.references :rank, :user, :topic
      t.timestamps
    end
  end
  
  def down
    drop_table :assessments
  end
  
end