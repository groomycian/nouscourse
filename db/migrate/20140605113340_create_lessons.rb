class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name, null:false
      t.text :description
      t.integer :order, null:false
      t.integer :course_id, null:false

      t.timestamps
    end
    add_index :lessons, :name, :unique => true
    add_index :lessons, [:course_id, :order], :unique => true
  end
end
