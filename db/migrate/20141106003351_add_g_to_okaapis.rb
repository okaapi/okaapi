class AddGToOkaapis < ActiveRecord::Migration
  def change
    add_column :okaapis, :g, :string, default: "false"
  end
end
