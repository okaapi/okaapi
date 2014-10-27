class AddDiaryToUser < ActiveRecord::Migration
  def change
    add_column :auth_users, :diary_service, :string, default: "off"
  end
end
