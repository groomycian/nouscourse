class Lesson < ActiveRecord::Base
  belongs_to :course

  default_scope -> { order('"order" ASC') }

  validates :name, presence: true, length: { maximum: 255 }
  validates :order, presence: true, :numericality => {:only_integer => true}
  validates :course_id, presence: true, :numericality => {:only_integer => true}
end
