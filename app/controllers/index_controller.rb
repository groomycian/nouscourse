class IndexController < ApplicationController
  def index
    @courses = Course.order('name ASC')
    @current_course = Course.find_by(name: params[:course_name])
    @current_course = Course.order('name ASC').first if @current_course.nil?
    @lessons = @current_course.lessons.paginate(page: params[:page])
  end
end
