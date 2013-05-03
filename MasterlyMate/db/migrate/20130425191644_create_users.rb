class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :firstName
      t.string :lastName
      t.date :birthdate
      t.string :password_digest
      t.string :username
      t.string :email
      t.string :sex

      t.timestamps
    end
  end
end
