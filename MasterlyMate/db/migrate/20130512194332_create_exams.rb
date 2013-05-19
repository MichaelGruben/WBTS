class CreateExams < ActiveRecord::Migration
  def up
    create_table :exams do |t|
      t.integer :points
      t.references :wbt, :assessment
      t.timestamps
    end
  end

  def down
    drop_table :exams
  end
end
