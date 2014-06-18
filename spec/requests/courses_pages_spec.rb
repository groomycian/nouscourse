require 'spec_helper'
require 'pp'

include AuthenticationHelpers

describe "Courses pages" do
	subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }

  describe 'check list page' do
    let(:target_path) { courses_path }

    it_should_behave_like 'check_access_to_page', 'Все курсы'

    describe 'successed sign in' do
      before do
        valid_sign_in admin
        visit target_path
      end

      it { should have_title('Все курсы') }
      it { should have_content('Все курсы') }

      describe "pagination" do

        before(:all) { 31.times { FactoryGirl.create(:course) } }
        after(:all)  { Course.delete_all }

        it { should have_selector('div.pagination') }

        it "should list each course" do
          Course.paginate(page: 1).each do |course|
            expect(page).to have_selector('li', text: course.name)
            should have_link('', href: edit_course_path(course))
            should have_link('', href: course_path(course))
          end
        end
      end
    end
  end

  describe 'check new page' do
    let(:target_path) { new_course_path }

    it_should_behave_like 'check_access_to_page', 'Новый курс'

    describe 'successed sign in' do
      before do
        valid_sign_in admin
        visit target_path
      end

      it { should have_title('Новый курс') }
      it { should have_content('Новый курс') }
      it { should have_button('Создать новый курс') }

      describe 'create new user' do
        let(:submit) { "Создать новый курс" }

        describe 'with wrong info' do
          it "should not create a course" do
            expect { click_button submit }.not_to change(User, :count)
          end

          describe 'after form submission' do
            before { click_button submit }

            it { should have_title('Новый курс') }
            it { should have_error_message('Форма содержит') }
          end
        end

        describe 'with correct info' do
          let(:course) { FactoryGirl.build(:course) }

          before { fill_course_with_valid_info(course) }

          it "should create a course" do
            expect { click_button submit }.to change(Course, :count).by(1)
          end

          describe 'after form submission' do
            before { click_button submit }

            it { should have_success_message('Новый курс был создан') }
            it { should have_title('Все курсы') }
          end
        end
      end
    end
  end

  describe 'check edit page' do
    let(:course) { FactoryGirl.create(:course) }
    let(:target_path) { edit_course_path(course) }

    it_should_behave_like 'check_access_to_page', 'Редактировать курс'

    describe 'edit user' do
      let (:submit) { "Редактировать курс" }

      before do
        valid_sign_in admin
        visit target_path
      end

      it { should have_title('Редактировать курс') }
      it { should have_content('Редактировать курс') }
      it { should have_button('Редактировать курс') }

      describe 'with wrong info' do
        before { fill_in "Name", with: ''  }

        it "should not update a course" do
          expect { click_button submit }.not_to change(Course, :count)
        end

        describe 'after form submission' do
          before { click_button submit }

          it { should have_title('Редактировать курс') }
          it { should have_error_message('Форма содержит') }
        end
      end

      describe 'with correct info' do
        let!(:old_course_name) { course.name }

        before { fill_in "Name", with: 'Another course name' }

        it "should update a course" do
          expect { click_button submit }.not_to change(Course, :count)
        end

        describe 'after form submission' do
          before do
            click_button submit
            course.reload
          end

          it { should have_success_message('Курс был изменён') }
          it { should have_title('Все курсы') }
          it { expect(course.name).not_to eq old_course_name }
        end
      end
    end
  end

  describe 'destroy request' do
    let!(:course) { FactoryGirl.create(:course) }

    describe 'from the list page' do
      describe 'with admin user' do
        before do
          valid_sign_in admin
          visit courses_path
        end

        it "should be able to delete course" do
          expect do
            first('ul.list-items a[data-method="delete"]').click
          end.to change(Course, :count).by(-1)
        end
      end
    end

    describe 'check redirect' do
      describe 'with admin user' do
        before do
          valid_sign_in admin, no_capybara: true
          delete course_path(course)
        end

        specify { expect(response).to redirect_to(courses_path) }
      end

      describe 'with simple user' do
        before do
          valid_sign_in user, no_capybara: true
          delete course_path(course)
        end

        specify { expect(response).to redirect_to(root_path) }
      end
    end
  end
end
