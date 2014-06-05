require 'spec_helper'

describe Course do
  let (:course) { Course.new(name: "Example course") }

  subject { course }

  it { should respond_to(:name) }

  describe "when name is not present" do
    before { course.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { course.name = 'h' * 128 }
    it { should_not be_valid }
  end

  describe "when name is already taken" do
    before do
      course_duplication = course.dup
      course_duplication.name = course.name.upcase
      course_duplication.save()
    end

    it { should_not be_valid }
  end

  describe "lesson associations" do
    before { course.save() }

    let!(:second_lesson) do
      FactoryGirl.create(:lesson, course: course, order: 2)
    end

    let!(:first_lesson) do
      FactoryGirl.create(:lesson, course: course, order: 1)
    end

    it 'lessons should have right order' do
      expect(course.lessons.to_a).to eq [first_lesson, second_lesson]
    end
  end
end
