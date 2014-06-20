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

    describe 'successed sign in' do
      before do
        valid_sign_in admin
        visit target_path
      end

      it { should have_title('Новый урок') }
      it { should have_content('Новый урок') }
      it { should have_button('Создать новый урок') }
      it { should have_selector("form[action='#{course_lessons_path(course)}']") }

      describe 'create new lesson' do
        let(:submit) { "Создать новый урок" }

        describe 'with wrong info' do
          it "should not create a lesson" do
            expect { click_button submit }.not_to change(User, :count)
          end

          describe 'after form submission' do
            before { click_button submit }

            it { should have_title('Новый урок') }
            it { should have_error_message('Форма содержит') }
          end
        end

        describe 'with correct info' do
          let(:lesson) { FactoryGirl.build(:lesson, course: course) }

          before { fill_lesson_with_valid_info(lesson) }

          it "should create a course" do
            expect { click_button submit }.to change(Lesson, :count).by(1)
          end

          describe 'after form submission' do
            before { click_button submit }

            it { should have_success_message('Новый урок был создан') }
            it { should have_title('Список уроков для курса') }
          end
        end
      end
    end
  end

  describe 'check list page' do
    let(:target_path) { course_lessons_path(course) }

    it_should_behave_like 'check_access_to_page', 'Список уроков для курса'

    describe 'successed sign in' do
      before do
        valid_sign_in admin
        page.set_rack_session(:back_url => courses_path)
        visit target_path
      end

      it { should have_title('Список уроков для курса') }
      it { should have_content('Список уроков для курса') }
      it { should have_link('Добавить урок', href: new_course_lesson_path(course)) }
      it { should have_link('Назад', href: courses_path) }

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
