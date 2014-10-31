class CreateOkaapis < ActiveRecord::Migration
  def change
    create_table :okaapis do |t|
      t.string :subject
      t.text :content
      t.timestamp :time
      t.string :from
      t.string :reminder, default:  0
      t.string :archived, default: "false"
      t.integer :user_id, default:  0

      t.timestamps
    end
  end
end
