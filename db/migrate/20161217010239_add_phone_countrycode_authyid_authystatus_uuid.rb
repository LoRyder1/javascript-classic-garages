class AddPhoneCountrycodeAuthyidAuthystatusUuid < ActiveRecord::Migration
  def change
    add_column :users, :phone_number, :string
    add_column :users, :country_code, :string
    add_column :users, :authy_id, :string
    add_column :users, :authy_status, :integer, :null => false, :default => 0
    add_column :users, :uuid, :string
  end
end
