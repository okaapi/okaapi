class AddGToOkaapis < ActiveRecord::Migration[5.0]
  def change
    add_column :okaapis, :g, :string, default: "false"
  end
end
