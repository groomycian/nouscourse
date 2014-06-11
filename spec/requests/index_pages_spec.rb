require 'spec_helper'

describe 'IndexPages' do
	subject { page }

	describe 'home page' do
    let!(:courses) { [FactoryGirl.create(:course), FactoryGirl.create(:course), FactoryGirl.create(:course)] }
    let(:first_course) { Course.order('name ASC').first }

    before { visit root_path }

    it { should have_title(full_title('')) }

    it_should_behave_like 'check_all_lessons_pagination', 1
    it_should_behave_like 'check_all_lessons_pagination', 2
    it_should_behave_like 'check_all_lessons_pagination', 3

    it_should_behave_like 'check_lesson_comming_feed'

    describe 'course buttons' do
      before { visit root_path }


      it "should have courses" do
        expect(Course.count).not_to eql(0)
      end

      #TODO: check all pages
      it 'should have all lessons' do
        Lesson.paginate(page: 2) do |lesson|
          expect(page).to have_selector('li', text: lesson.name)
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
