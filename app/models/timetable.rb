class Timetable < ActiveRecord::Base
  belongs_to :lesson

  validates :lesson_id, presence: true, :numericality => {:only_integer => true}
  validates :date, presence: true

  scope :comming, -> { where('"date" >= ?', Date.today) }
end
