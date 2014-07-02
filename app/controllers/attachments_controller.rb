class TimetablesController < ApplicationController
  before_action :do_before_action

  respond_to :js

  def new
    @attachment = Attachment.new(lesson: Lesson.find(params[:lesson_id]))
  end

  def create
    @lesson = Lesson.find(params[:lesson_id])
    @attachment = @lesson.attachments.build(timetable_params)

    respond_to_parent do |format|
      if @attachment.save
        format.js
      else
        format.js { render action: "new" }
      end
    end
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    respond_with @attachment
  end

  private
  def do_before_action
    signed_in_user
    admin_user
  end

  def timetable_params
    params.require(:attachment).permit(:file_file_name)
  end
end
