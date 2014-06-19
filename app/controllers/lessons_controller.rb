class LessonsController < ApplicationController
  before_action :signed_in_user, only: [:index, :create, :new, :edit, :update, :destroy]
  before_action :admin_user, only: [:index, :create, :new, :edit, :update, :destroy]

  def index
    @course = Course.find(params[:course_id])
    @lessons = @course.lessons.paginate(page: params[:page])
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

  private
  def course_params

  end
end
