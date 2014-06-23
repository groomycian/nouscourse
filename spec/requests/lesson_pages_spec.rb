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

    describe 'edit course' do
      let (:submit) { "Редактировать урок" }

      before do
        valid_sign_in admin
        visit target_path
      end

      it { should have_title('Редактировать урок') }
      it { should have_content('Редактировать урок') }
      it { should have_button('Редактировать урок') }

      describe 'with wrong info' do
        before do
          fill_in "Name", with: ''
          fill_in "Description", with: ''
        end

        it "should not create a lesson" do
          expect { click_button submit }.not_to change(Lesson, :count)
        end

        describe 'after form submission' do
          before { click_button submit }

          it { should have_title('Редактировать урок') }
          it { should have_error_message('Форма содержит') }
        end
      end
    end
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
          before do
            fill_in "Name", with: ''
            fill_in "Description", with: ''
          end

          it "should not create a lesson" do
            expect { click_button submit }.not_to change(Lesson, :count)
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
          31.times do
            FactoryGirl.create(:lesson, course: course)
          end

          course.lessons.each_with_index do |lesson, i|
            5.times { FactoryGirl.create(:timetable, lesson: lesson, date: Date.today + i) }
          end

          visit target_path
        end

        after  { Lesson.delete_all }

        it { should have_selector('div.pagination') }
        it { Timetable.count.should eql Lesson.count * 5 }

        it "should list each course" do
          course.lessons.paginate(page: 1).each do |lesson|
            expect(page).to have_selector('li', text: lesson.name)
            should have_link('', href: edit_course_lesson_path(course, lesson))
            should have_link('', href: course_lesson_path(course, lesson))

            lesson.timetables.each do |timetable|
              should have_selector("ul#timetables-#{lesson.id} span", text: I18n.l(timetable.date, :format => :default).strip)
            end
          end
        end
      end
    end
  end

  describe 'destroy request' do
    let!(:lesson) { FactoryGirl.create(:lesson, course: course) }

    describe 'from the list page' do
      describe 'with admin user' do
        before do
          valid_sign_in admin
          visit course_lessons_path(course)
        end

        it "should be able to delete lesson" do
          expect do
            first('ul.list-items a[data-method="delete"]').click
          end.to change(Lesson, :count).by(-1)
        end
      end
    end

    describe 'check redirect' do
      describe 'with admin user' do
        describe 'remove single lesson' do
          before do
            valid_sign_in admin, no_capybara: true
            delete course_lesson_path(course, lesson)
          end

          specify { expect(response).to redirect_to(course_lessons_path(course)) }
        end

        describe 'remove all lessons' do
          let(:another_course) { Course.create(name: 'Another test course') }
          let(:lessons_count) { 20 }

          before do
            lessons_count.times do
              FactoryGirl.create(:lesson, course: another_course)
            end

            valid_sign_in admin
            visit course_lessons_path(another_course)
          end

          it { another_course.lessons.count.should eql lessons_count }
          it { should have_link('Удалить все уроки', href: course_lessons_path(another_course)) }

          describe 'delete courses' do
            it "should be able to delete lessons" do
              expect do
                click_link 'Удалить все уроки'
              end.to change(Lesson, :count).by(-another_course.lessons.count)
            end
          end
        end
      end

      describe 'with simple user' do
        describe 'remove single course' do
          before do
            valid_sign_in user, no_capybara: true
            delete course_lesson_path(course, lesson)
          end

          specify { expect(response).to redirect_to(root_path) }
        end

        describe 'remove all lessons' do
          before do
            valid_sign_in user, no_capybara: true
            delete course_lessons_path(course)
          end

          specify { expect(response).to redirect_to(root_path) }
        end
      end
    end
  end
end
