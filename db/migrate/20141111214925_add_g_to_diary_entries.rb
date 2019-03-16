class AddGToDiaryEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :diary_entries, :g, :string, default: "false"
  end
end
