class LessonsController < ApplicationController
  before_action :signed_in_user, only: [:index, :create, :new, :edit, :update, :destroy]
  before_action :admin_user, only: [:index, :create, :new, :edit, :update, :destroy]
  before_action :load_course

  def index
    @lessons = @course.lessons.paginate(page: params[:page])
    @back_url = self.back_url
    @back_url = courses_path if @back_url.nil?
  end

  def new
    @lesson = @course.lessons.new
  end

  def edit
    @lesson = Lesson.find(params[:id])
  end

  def create
    @lesson = @course.lessons.new(lesson_params)
    if @lesson.save
      flash[:success] = "Новый урок был создан"
      redirect_to course_lessons_path(@course)
    else
      render 'new'
    end
  end

  def update
  end

  def destroy
  end

  private
    def load_course
      @course = Course.find(params[:course_id])
    end

    def lesson_params
      params.require(:lesson).permit(:name, :description)
    end
end
