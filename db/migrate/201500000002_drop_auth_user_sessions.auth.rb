# This migration comes from auth (originally 20141008203151)
class DropAuthUserSessions < ActiveRecord::Migration
  def change
    drop_table :auth_user_sessions 
  end
end
