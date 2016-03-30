class AddDiaryServiceToUser < ActiveRecord::Migration
  def change
    add_column :users, :diary_service, :string, default: "off"
  end
end
