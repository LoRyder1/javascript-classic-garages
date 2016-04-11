class CreateGarages < ActiveRecord::Migration
  def change
    create_table :garages do |t|
      t.string :name
      t.string :car_type
      t.float :year

      t.timestamps null: false
    end
  end
end
