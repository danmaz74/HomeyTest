class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects, id: :uuid do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users }, type: :uuid

      t.string :name
      t.string :description

      t.string :status

      t.timestamps
    end
  end
end
