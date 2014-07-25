class AddDescriptionToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :description, :text, null:false, default: ''
  end
end
