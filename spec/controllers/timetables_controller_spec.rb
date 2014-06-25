require 'spec_helper'
require 'pp'

describe TimetablesController do

  let(:admin) { FactoryGirl.create(:admin) }
  let(:course) { FactoryGirl.create(:course) }
  let(:lesson) { FactoryGirl.create(:lesson, course: course) }

  before { valid_sign_in admin, no_capybara: true }

  describe "creating a timetable with Ajax" do

    it "should increment the timetable count" do
      expect do
        xhr :post, :create, timetable: {date: Date.today}, lesson_id: lesson.id
      end.to change(Timetable, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, timetable: {date: Date.today}, lesson_id: lesson.id
      expect(response).to be_success
    end
  end

  describe "destroying a timetable with Ajax" do

    let!(:timetable) { FactoryGirl.create(:timetable, lesson: lesson ) }

    it "should decrement the timetable count" do
      expect do
        xhr :delete, :destroy, id: timetable.id
      end.to change(Timetable, :count).by(-1)
    end

    it "should respond with success" do
      xhr :delete, :destroy, id: timetable.id
      expect(response).to be_success
    end
  end
end