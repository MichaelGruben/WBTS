class AddColumnToTable < ActiveRecord::Migration
  def change
    add_column :courses, :mainFile, :string
    add_column :courses, :description, :string
    add_column :courses, :name, :string
    add_column :courses, :pathToFile, :string
    add_column :courses, :forRank, :integer
  end
end
