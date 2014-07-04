class AttachmentsController < ApplicationController
  before_action :do_before_action

  respond_to :html, :js

  def new
    @attachment = Attachment.new(lesson: Lesson.find(params[:lesson_id]))
    respond_to do |format|
      format.js { render action: "new" }
    end
  end

  def create
    @lesson = Lesson.find(params[:lesson_id])
    @attachment = @lesson.attachments.build(attachment_params)

    if @attachment.save
      responds_to_parent do
        render 'create', :layout => false
      end
    else
      responds_to_parent do
        render 'new', :layout => false
      end
    end
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    respond_to do |format|
      format.js { render action: "destroy" }
    end
  end

  private
  def do_before_action
    signed_in_user
    admin_user
  end

  def attachment_params
    params.fetch(:attachment, {}).permit(:file)
  end
end
