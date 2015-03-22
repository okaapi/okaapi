# This migration comes from auth (originally 20141008210341)
class DropAuthUserActions < ActiveRecord::Migration
  def change
    drop_table :auth_user_actions 
  end
end
