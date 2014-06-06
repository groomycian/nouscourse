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
  before { click_button course.name }

  it { expect(page).should have_selector("a[href='" + course_name_url(click_button course.name) + "'].btn.btn-primary",
                                        text:course.name) }
end

shared_examples_for 'check_course_pagination' do
  before do
    30.times { FactoryGirl.create(:lesson, course: course) }

    click_button course.name
  end

  after { course.lessons.delete_all }

  it { should have_selector('div.pagination') }

  it "should list each lesson" do
    course.lessons.paginate(page: 1).each do |lesson|
      expect(page).to have_selector('li', text: lesson.name)
    end
  end
end