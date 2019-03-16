class AddDiaryServiceToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :diary_service, :string, default: "off"
  end
end
