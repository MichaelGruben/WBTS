class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :firstName
      t.string :lastName
      t.date :Birthdate
      t.string :password
      t.string :username
      t.string :email

      t.timestamps
    end
  end
end
