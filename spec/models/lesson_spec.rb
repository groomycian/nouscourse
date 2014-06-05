require 'spec_helper'

describe Lesson do
  let(:course) { FactoryGirl.create(:course) }

  let (:lesson) { course.lesson.build(name: "new course", order: 1) }

  subject { lesson }

  it { should respond_to(:name) }
  it { should respond_to(:order) }
  it { should respond_to(:description) }
  it { should respond_to(:course) }

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

  describe "when lesson order is empty" do
    before { lesson.order = nil }
    it { should_not be_valid }
  end

  describe "when lesson order is not integer" do
    before { lesson.order = '12' }
    it { should_not be_valid }
  end

  describe "when lesson course is empty" do
    before { lesson.course = nil }
    it { should_not be_valid }
  end
end
