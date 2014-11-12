class AddGToDiaryEntries < ActiveRecord::Migration
  def change
    add_column :diary_entries, :g, :string, default: "false"
  end
end
