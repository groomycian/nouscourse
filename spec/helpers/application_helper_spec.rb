require 'spec_helper'

describe ApplicationHelper do
  def generate_lessons_data(course)
    let(:another_course) { FactoryGirl.create(:course) }

    before do
      60.times { |i| FactoryGirl.create(:lesson, course: course, order: i) }
      60.times { |i| FactoryGirl.create(:lesson, course: another_course, order: i) }

      first(:link, course.name).click
    end

    after { Lesson.delete_all }
  end
end
