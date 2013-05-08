class UsersHaveAndBelongsToManyRanks < ActiveRecord::Migration
  def up
    create_table :ranks_users, id: false do |t|
      t.references :rank, :user, :topics
    end
  end

  def down
    drop_table :ranks_users
  end
end
