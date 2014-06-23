class CoursesController < ApplicationController
  before_action :signed_in_user, only: [:index, :create, :new, :edit, :update, :destroy]
  before_action :admin_user, only: [:index, :create, :new, :edit, :update, :destroy]

  def index
    @courses = Course.paginate(page: params[:page])

    self.back_url = request.original_url
  end

  def new
    @course = Course.new
  end

  def edit
    @course = Course.find(params[:id])
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      flash[:success] = "Новый курс был создан"
      redirect_to courses_path
    else
      render 'new'
    end
  end

  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(course_params)
      flash[:success] = "Курс был изменён"
      redirect_to courses_path
    else
      render 'edit'
    end
  end

  def destroy
    course = Course.find(params[:id])
    flash[:success] = "Выбранный курс был удалён"
    course.destroy

    redirect_to courses_path
  end

  private
    def course_params
      params.require(:course).permit(:name)
    end
end
