class AddColumnToWbts < ActiveRecord::Migration
  def change
    add_column :wbts, :mainFile, :string
    add_column :wbts, :description, :string
    add_column :wbts, :topic, :integer
    add_column :wbts, :forRank, :integer
  end
end
