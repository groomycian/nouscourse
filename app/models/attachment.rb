class Attachment < ActiveRecord::Base
  has_attached_file :file

  belongs_to :lesson

  validates :file, attachment_presence: true
  validates_with AttachmentPresenceValidator, attributes: :file
end
