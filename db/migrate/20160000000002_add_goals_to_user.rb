class AddGoalsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :goal, :string, default: ""
    add_column :users, :goal_in_subject, :string, default: ""
  end
end
