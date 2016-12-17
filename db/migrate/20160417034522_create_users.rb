
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :display_name
      t.string :email, null: false
      t.string :password_digest, null: false

      t.timestamps null: false
    end
  end
end
