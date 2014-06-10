include ApplicationHelper

def full_title(page_title)
  base_title = "Ruby on Rails Tutorial Sample App"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-danger', text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-success', text: message)
  end
end

shared_examples_for "switch_to_primary_button" do
  before { first(:link, course.name).click }

  it { should have_title(full_title('Текущий курс ' + course.name)) }
  it { should have_selector("a.btn.btn-primary", text:course.name) }
end

shared_examples_for 'check_all_lessons_pagination' do |pagination_page|
  let(:first_course) { FactoryGirl.create(:course) }
  let(:second_course) { FactoryGirl.create(:course) }
  let(:third_course) { FactoryGirl.create(:course) }

  before do
    30.times { |i| FactoryGirl.create(:lesson, course: first_course, order: i) }
    30.times { |i| FactoryGirl.create(:lesson, course: second_course, order: i) }
    30.times { |i| FactoryGirl.create(:lesson, course: third_course, order: i) }

    visit root_path

    first('div.pagination').click_link(pagination_page)
  end

  after do
    first_course.lessons.delete_all
    second_course.lessons.delete_all
    third_course.lessons.delete_all
  end

  it { should have_selector('div.pagination') }

  it "should list each lesson" do
    Lesson.paginate(page: pagination_page).each do |lesson|
      expect(page).to have_selector('li', text: lesson.name)
    end
  end
end

shared_examples_for 'check_course_pagination' do
  let(:another_course) { FactoryGirl.create(:course) }

  before do
    60.times { |i| FactoryGirl.create(:lesson, course: course, order: i) }
    60.times { |i| FactoryGirl.create(:lesson, course: another_course, order: i) }

    first(:link, course.name).click
  end

  after { Lesson.delete_all }

  it { should have_selector('div.pagination') }

  it "should list each lesson" do
    course.lessons.paginate(page: 1).each do |lesson|
      expect(page).to have_selector('li', text: lesson.name)
    end
  end
end