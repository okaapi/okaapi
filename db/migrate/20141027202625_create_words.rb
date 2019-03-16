class CreateWords < ActiveRecord::Migration[5.0]
  def change
    create_table :words do |t|
      t.string :term
      t.integer :priority, default:  0
      t.string :person, default:  "false"
      t.string :archived, default:  "false"
      t.integer :user_id, default:  0

      t.timestamps
    end
  end
end
