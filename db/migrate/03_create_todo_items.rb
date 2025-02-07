class CreateTodoItems < ActiveRecord::Migration[8.0]
  def change
    create_table :todo_items do |t|
      t.string :title, null: false
      t.boolean :completed, default: false
      t.references :todo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
