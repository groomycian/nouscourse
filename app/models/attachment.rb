class Attachment < ActiveRecord::Base
  has_attached_file :file

  belongs_to :lesson

  validates :file, attachment_presence: true
  do_not_validate_attachment_file_type :file
end
