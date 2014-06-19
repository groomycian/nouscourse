require 'spec_helper'
require 'pp'

include AuthenticationHelpers

describe "lesson pages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }

  #can not use FactoryGirl, it looks like bug with sequence feature + it_should_behave_like
  let(:course) { Course.create(name: 'Test course') }

  describe 'check edit page' do
    let(:lesson) { FactoryGirl.create(:lesson, course: course) }
    let(:target_path) { edit_course_lesson_path(course, lesson) }

    it_should_behave_like 'check_access_to_page', 'Редактировать урок'
  end

  describe 'check new page' do
    let(:target_path) { new_course_lesson_path(course) }

    it_should_behave_like 'check_access_to_page', 'Новый урок'
  end

  describe 'check list page' do
    let(:target_path) { course_lessons_path(course) }

    it_should_behave_like 'check_access_to_page', 'Список уроков для курса'

    describe 'successed sign in' do
      before do
        valid_sign_in admin
        visit target_path
      end

      it { should have_title('Список уроков для курса') }
      it { should have_content('Список уроков для курса') }
      it { should have_link('Добавить урок', href: new_course_lesson_path(course)) }

      describe "pagination" do

        before do
          31.times { FactoryGirl.create(:lesson, course: course) }
          visit target_path
        end

        after  { Lesson.delete_all }

        it { should have_selector('div.pagination') }

        it "should list each course" do
          Lesson.paginate(page: 1).each do |lesson|
            expect(page).to have_selector('li', text: lesson.name)
            should have_link('', href: edit_course_lesson_path(course, lesson))
            should have_link('', href: course_lesson_path(course, lesson))
          end
        end
      end
    end
  end
end
