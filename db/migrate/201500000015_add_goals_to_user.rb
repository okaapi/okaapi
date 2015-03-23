class AddGoalsToUser < ActiveRecord::Migration
  def change
    add_column :users, :goal, :string, default: ""
    add_column :users, :goal_in_subject, :string, default: ""
  end
end
