# This migration comes from auth (originally 20141007223736)
class DropAuthUsers < ActiveRecord::Migration
  def change
    drop_table :auth_users 
  end
end
