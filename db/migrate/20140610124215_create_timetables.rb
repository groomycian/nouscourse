class CreateTimetables < ActiveRecord::Migration
  def change
    create_table :timetables do |t|
      t.integer :lesson_id, null:false
      t.date :date, null:false

      t.timestamps
    end
    add_index :timetables, [:lesson_id, :date]
  end
end
