class TimetablesController < ApplicationController
  before_action :do_before_action

  respond_to :js

  def new
    @timetable = Timetable.new(lesson: Lesson.find(params[:lesson_id]))
  end

  def create
    @lesson = Lesson.find(params[:lesson_id])
    @timetable = @lesson.timetables.build(timetable_params)

    respond_to do |format|
      if @timetable.save
        format.js
      else
        format.js { render action: "new" }
      end
    end
  end

  def destroy
    @timetable = Timetable.find(params[:id])
    @timetable.destroy
    respond_with @timetable
  end

  private
    def do_before_action
      signed_in_user
      admin_user
    end

    def timetable_params
      params.require(:timetable).permit(:date)
    end
end
