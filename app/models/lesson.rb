class Lesson < ActiveRecord::Base
  has_many :attachments, dependent: :destroy

  belongs_to :course
  has_many :timetables, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
  validates :course_id, presence: true, :numericality => {:only_integer => true}
end
