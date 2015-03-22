class AddDiaryServiceToUser < ActiveRecord::Migration
  def change
    add_column :users, :diary_service, :string, default: "off"
    #add_column :users, :mindmap_service, :string, default: "off"
    #add_column :users, :goal, :string, default: ""
    #add_column :users, :goal_in_subject, :string, default: ""
  end
end
