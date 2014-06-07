require 'spec_helper'

describe 'IndexPages' do
	subject { page }

	describe 'home page' do
    let!(:courses) { [FactoryGirl.create(:course), FactoryGirl.create(:course), FactoryGirl.create(:course)] }
    let(:first_course) { Course.order('name ASC').first }

    before { visit root_path }

    it { should have_title(full_title('Текущий курс ' + first_course.name)) }

    describe 'course buttons' do
      before { visit root_path }


      it "should have courses" do
        expect(Course.count).not_to eql(0)
      end

      it 'should have course buttons' do
        Course.order('name ASC').each do |course, i|
          should have_selector('a.btn-' + (first_course.id == course.id ? 'primary' : 'default'), text:course.name)
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
