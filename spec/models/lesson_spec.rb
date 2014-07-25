require 'spec_helper'

describe Lesson do
  let(:course) { FactoryGirl.create(:course) }

  let (:lesson) { course.lessons.build(name: "new course") }

  subject { lesson }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:course) }
  it { should respond_to(:timetables) }
  it { should respond_to(:attachments) }

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

  describe "lesson attachments" do
    let(:lesson) { FactoryGirl.create(:lesson, course: course) }
    let(:attachment_feed){
      [
          FactoryGirl.create(:attachment, lesson: lesson),
          FactoryGirl.create(:attachment, lesson: lesson),
          FactoryGirl.create(:attachment, lesson: lesson)
      ]
    }

    describe "feed" do
      it 'should contain add attachments' do
        lesson.attachments.should eq attachment_feed
      end
    end
  end
end
