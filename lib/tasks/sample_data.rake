namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		make_courses
		make_lessons
    make_timetables
    make_users
	end
end

def make_courses
	4.times do |n|
    name = Faker::Lorem.word
    Course.create!(name: name + "#{n}")
	end
end

def make_users
  user = User.create!(name:     "Example User",
                       email:    "exampl1e@user.org",
                       password: "qwerty",
                       password_confirmation: "qwerty",
                       admin: false)

  admin = User.create!(name:     "Example User",
                       email:    "example@user.org",
                       password: "qwerty",
                       password_confirmation: "qwerty",
                       admin: true)
end

def make_lessons
	courses = Course.all
	20.times do |i|
		courses.each do |course|
      name = Faker::Lorem.sentence(1, true)
      description = Faker::Lorem.sentence(5)

      course.lessons.create!(name: name, description: description)
    end
	end
end

def make_timetables
  lessons = Lesson.all
  5.times do |i|
    lessons.each do |lesson|
      lesson.timetables.create!(date: (Date.today - 2)  + i)
    end
  end
end