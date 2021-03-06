class Course < ActiveRecord::Base
  has_many :lessons, dependent: :destroy
  validates :name, presence: true, length: { maximum: 127 }, uniqueness: { case_sensitive: false }

  def find_lesson_by_id(id)
    lessons.find(id)
  end
end
