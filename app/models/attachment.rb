class Attachment < ActiveRecord::Base
  has_attached_file :file

  belongs_to :lesson

  validates :description, presence: true
  validates :file, attachment_presence: true
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
