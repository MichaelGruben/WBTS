class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :firstName
      t.string :lastName
      t.date :birthdate
      t.string :password_digest
      t.string :username
      t.string :email
      t.boolean :sex
      t.string :zipCode
      t.string :city
      t.string :state
      t.timestamps
    end
  end
  
  def down
    drop_table :users
  end
  
end
