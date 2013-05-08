class AddColumnsToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :parent_name, :string
  end
end
