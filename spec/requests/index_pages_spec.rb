require 'spec_helper'

describe 'IndexPages' do
	subject { page }

	describe 'home page' do
    before { visit root_path }

    it { should have_title(full_title('Добро пожаловать в nouscourse')) }

    describe 'course buttons' do
      let(:courses) { [FactoryGirl.create(:course), FactoryGirl.create(:course), FactoryGirl.create(:course)] }

      it 'should have course buttons' do
        courses.each do |course, i|
          should have_selector("a[href='" + course_name_url(course.name) + "'].btn.btn-" +
                                   (i == 0 ? 'default' : 'primary'), text:course.name)
        end
      end

      describe 'button 1 should be checked' do
        let(:course) { courses[0] }

        it_should_behave_like "switch_to_primary_button"

        describe "course 1 lessons pagination" do
          it_should_behave_like 'check_course_pagination'
        end
      end

      describe 'button 2 should be checked' do
        let(:course) { courses[1] }

        it_should_behave_like "switch_to_primary_button"

        describe "course 2 lessons pagination" do
          it_should_behave_like 'check_course_pagination'
        end
      end

      describe 'button 3 should be checked' do
        let(:course) { courses[2] }

        it_should_behave_like "switch_to_primary_button"

        describe "course 3 lessons pagination" do
          it_should_behave_like 'check_course_pagination'
        end
      end
    end
  end
end
