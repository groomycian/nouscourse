class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name, null: false
      t.text :description
      t.integer :order, null: false

      t.timestamps
    end
    add_index :lessons, :name
    add_index :lessons, :order
  end
end
