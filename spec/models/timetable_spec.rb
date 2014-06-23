require 'spec_helper'
require 'pp'

describe Timetable do
  let(:course) { FactoryGirl.build(:course) }
  let(:lesson) { FactoryGirl.build(:lesson, course: course) }
  let(:timetable) { FactoryGirl.build(:timetable, lesson: lesson) }

  subject { timetable }

  it { should respond_to(:lesson_id) }
  it { should respond_to(:date) }
  it { should respond_to(:lesson) }
  it { should respond_to(:print_date) }

  describe "when date is missing" do
    before { timetable.date = ''}

    it { should_not be_valid }

    describe 'or is wrong' do
      before { timetable.date = 'dsadsadsa' }

      it { should_not be_valid }
    end
  end

  describe "when lesson id is missing" do
    before { timetable.lesson_id = '' }

    it { should_not be_valid }

    describe 'or is wrong' do
      before { timetable.lesson_id = 'dsadsadsa' }

      it { should_not be_valid }
    end
  end

  describe "feed" do
    let(:course) { FactoryGirl.create(:course) }
    let(:lessons) { [FactoryGirl.create(:lesson, course: course), FactoryGirl.create(:lesson, course: course),
                     FactoryGirl.create(:lesson, course: course), FactoryGirl.create(:lesson, course: course),
                     FactoryGirl.create(:lesson, course: course)] }
    before do
      lessons.each do |lesson|
        FactoryGirl.create(:timetable, lesson: lesson)
      end
    end

    it "should have items" do
      Timetable.comming(nil).count.should_not eq 0
    end

    describe "comming/old" do
      let!(:old_timetables) {[FactoryGirl.create(:timetable, lesson: lessons[0], date: Date.today - 2),
                             FactoryGirl.create(:timetable, lesson: lessons[0], date: Date.today - 1)]}

      it "gets only comming" do
        Timetable.comming(nil).should_not include *old_timetables
      end

      it "gets old too" do
        Timetable.all.should include *old_timetables
      end

      describe 'order' do
        it 'should be ordered by date' do
          date = nil
          Timetable.comming(nil).each do |timetable|
            if date.nil?
              date = timetable.date
            end

            timetable.date.should >= date
            date = timetable.date
          end
        end
      end
    end
  end
end
