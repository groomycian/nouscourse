namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		make_courses
		make_lessons
	end
end

def make_courses
	4.times do |n|
		name = Faker::Lorem.sentence(1, true)
    Course.create!(name: name)
	end
end

def make_lessons
	courses = Course.all
	20.times do |i|
		courses.each do |course|
      name = Faker::Lorem.sentence(1, true)
      description = Faker::Lorem.sentence(5)
      order = i

      course.lessons.create!(name: name, description: description, order: order)
    end
	end
end