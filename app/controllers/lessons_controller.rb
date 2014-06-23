class LessonsController < ApplicationController
  before_action :signed_in_user, only: [:index, :create, :new, :edit, :update, :destroy, :destroy_all]
  before_action :admin_user, only: [:index, :create, :new, :edit, :update, :destroy, :destroy_all]
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
    @lesson = @course.find_lesson_by_id(params[:id])
    if @lesson.update_attributes(lesson_params)
      flash[:success] = "Урок был изменён"
      redirect_to course_lessons_path(@course)
    else
      render 'edit'
    end
  end

  def destroy
    lesson = @course.find_lesson_by_id(params[:id])
    flash[:success] = "Выбранный урок был удалён"
    lesson.destroy

    redirect_to course_lessons_path(@course)
  end

  def destroy_all
    flash[:success] = "Уроки были удалены"
    @course.lessons.destroy_all

    redirect_to course_lessons_path(@course)
  end

  private
    def load_course
      @course = Course.find(params[:course_id])
    end

    def lesson_params
      params.require(:lesson).permit(:name, :description)
    end
end
