class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :lesson_id, null:false
      t.attachment :file

      t.timestamps
    end
  end
end
