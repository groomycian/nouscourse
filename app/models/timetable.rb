class Timetable < ActiveRecord::Base
  belongs_to :lesson

  validates :lesson_id, presence: true, :numericality => {:only_integer => true}
  validates :date, presence: true

  scope :comming, -> (course) do
    composed_scope = self.all
    composed_scope = composed_scope.includes(:lesson).where('"date" >= ?', Date.today).order('date ASC')
    composed_scope = composed_scope.where('lessons.course_id = ?', course).references(:lesson) unless course.nil?

    composed_scope
  end

  def print_date
    date.strftime("%e %b %Y %H:%M:%S%p")
  end
end
