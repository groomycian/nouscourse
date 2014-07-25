require 'rack/test'
require 'spec_helper'

describe Attachment do
  let (:attachment) {
    FactoryGirl.build(
        :attachment,
        lesson:  FactoryGirl.create(
            :lesson,
            course: FactoryGirl.create(:course)
        )
    )
  }

  subject { attachment }

  it { should respond_to(:file) }
  it { should respond_to(:description) }
  it { should respond_to(:lesson) }

  describe "when file is not present" do
    before { attachment.file = nil }
    it { should_not be_valid }
  end

  describe "when description is not present" do
    before { attachment.description = " " }
    it { should_not be_valid }
  end

  describe "when lesson is not present" do
    before { attachment.lesson = nil }
    it { should_not be_valid }
  end
end
