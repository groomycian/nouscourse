class Lesson < ActiveRecord::Base
  belongs_to :course

  validates :name, presence: true, length: { maximum: 255 }
  validates :course_id, presence: true, :numericality => {:only_integer => true}
end
