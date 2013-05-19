class CreateWbts < ActiveRecord::Migration
  def change
    create_table :wbts do |t|
      t.string :name
      t.string :file
      t.references :rank
      t.timestamps
    end
  end
end
