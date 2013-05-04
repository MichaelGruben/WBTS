class CreateTestobjects < ActiveRecord::Migration
  def change
    create_table :testobjects do |t|

      t.timestamps
    end
  end
end
