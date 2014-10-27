class CreateDiaryEntries < ActiveRecord::Migration
  def change
    create_table :diary_entries do |t|
      t.timestamp :date
      t.integer :day, default: 0
      t.integer :month, default:  0
      t.integer :year, default:  0
      t.text :content      
      t.text :from
      t.string :archived, default:  "false"
      t.integer :user_id, default: 0

      t.timestamps
    end
  end
end

