class Attachment < ActiveRecord::Base
  has_attached_file :file

  belongs_to :lesson

  validates :file, attachment_presence: true
  validates_attachment_size :file, less_than: 25.megabytes

  do_not_validate_attachment_file_type :file

  def to_jq_upload
    {
      "size" => read_attribute(:file_file_size),
      "url" => file.url(:original),
      "delete_url" => "",
      "delete_type" => ""
    }
  end
end
