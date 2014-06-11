FactoryGirl.define do
  factory :course do
    sequence(:name)  { |n| "Course #{n}" }
  end

  factory :lesson do
    sequence(:name)  { |n| "Lesson #{n}" }
    description  'lesson description'
    course
  end

  factory :timetable do
    sequence(:date) { |n| (Date.today - 2)  + n }
    lesson
  end
end