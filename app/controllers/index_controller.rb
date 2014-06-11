class IndexController < ApplicationController
  def index
    @courses = Course.order('name ASC')
    @current_course = Course.find_by(name: params[:course_name])

    @timetables = Timetable.comming(@current_course).paginate(page: params[:page])
  end
end
