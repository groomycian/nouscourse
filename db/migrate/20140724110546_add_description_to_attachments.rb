class AddDescriptionToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :description, :text, null:false
  end
end
