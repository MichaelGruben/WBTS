class CreateWbts < ActiveRecord::Migration
  def change
    create_table :wbts do |t|
      t.string :name
      t.binary :file

      t.timestamps
    end
  end
end
