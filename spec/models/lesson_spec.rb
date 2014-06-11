require 'spec_helper'

describe Lesson do
  let(:course) { FactoryGirl.create(:course) }

  let (:lesson) { course.lessons.build(name: "new course") }

  subject { lesson }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:course) }
  it { should respond_to(:timetables) }

  its(:course) { should eq course }

  it { should be_valid }

  describe "when lesson name is empty" do
    before { lesson.name = ' ' }
    it { should_not be_valid }
  end

  describe "when lesson name is too long" do
    before { lesson.name = 'j' * 257 }
    it { should_not be_valid }
  end

  describe "when lesson course is empty" do
    before { lesson.course = nil }
    it { should_not be_valid }
  end
end
