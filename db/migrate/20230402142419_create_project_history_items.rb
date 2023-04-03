class CreateProjectHistoryItems < ActiveRecord::Migration[7.0]
  def change
    create_table :project_history_items, id: :uuid do |t|
      t.references :project, null: false, foreign_key: true, type: :uuid
      t.references :user, null: true, foreign_key: true, type: :uuid

      t.string :item_type
      t.string :content
      t.string :source # system or user name (user could have been deleted)

      t.timestamps
    end
  end
end
