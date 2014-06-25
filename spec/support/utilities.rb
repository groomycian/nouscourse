include ApplicationHelper

def full_title(page_title)
  base_title = "Ruby on Rails Tutorial Sample App"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def fill_course_with_valid_info(course)
  fill_in "Name", with: course.name
end

def fill_lesson_with_valid_info(lesson)
  fill_in "Name", with: lesson.name
  fill_in "Description", with: lesson.description
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
    30.times { |i| FactoryGirl.create(:lesson, course: first_course) }
    30.times { |i| FactoryGirl.create(:lesson, course: second_course) }
    30.times { |i| FactoryGirl.create(:lesson, course: third_course) }

    Lesson.all.each do |lesson|
      5.times {|i| FactoryGirl.create(:timetable, lesson: lesson) }
    end

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
    Timetable.comming(nil).paginate(page: pagination_page).each do |timetable|
      expect(page).to have_selector('li', text: timetable.lesson.name)
      expect(page).to have_selector('li span', text: I18n.l(timetable.date, :format => :default).strip)
    end
  end
end

shared_examples_for 'check_lesson_comming_feed' do
  let(:first_course) { FactoryGirl.create(:course) }
  let(:first_lesson) { FactoryGirl.create(:lesson, course: first_course) }
  let(:second_lesson) { FactoryGirl.create(:lesson, course: first_course) }
  let(:third_lesson) { FactoryGirl.create(:lesson, course: first_course) }

  before do
    #old
    FactoryGirl.create(:timetable, lesson: first_lesson, date: Date.today - 2)
    #old
    FactoryGirl.create(:timetable, lesson: second_lesson, date: Date.today - 1)
    #comming
    FactoryGirl.create(:timetable, lesson: third_lesson, date: Date.today)


    visit root_path
  end

  it 'should show only comming lessons' do
    expect(page).not_to have_selector('li', text: first_lesson.name)
    expect(page).not_to have_selector('li', text: second_lesson.name)
    expect(page).to have_selector('li', text: third_lesson.name)
  end
end

shared_examples_for 'check_course_pagination' do
  let(:another_course) { FactoryGirl.create(:course) }

  before do
    60.times { |i| FactoryGirl.create(:lesson, course: course) }
    60.times { |i| FactoryGirl.create(:lesson, course: another_course) }

    Lesson.all.each do |lesson|
      5.times {|i| FactoryGirl.create(:timetable, lesson: lesson) }
    end

    first(:link, course.name).click
  end

  after { Lesson.delete_all }

  it { should have_selector('div.pagination') }

  it "should list each lesson" do
    Timetable.comming(course).paginate(page: 1).each do |timetable|
      expect(timetable.lesson.course_id).to eql course.id
      expect(page).to have_selector('li', text: timetable.lesson.name)
      expect(page).to have_selector('li span', text: I18n.l(timetable.date, :format => :default).strip)
    end
  end
end