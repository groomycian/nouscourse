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

    respond_to do |format|
      if @attachment.save
        format.html {
          render :json => [@attachment.to_jq_upload].to_json,
                 :content_type => 'text/html',
                 :layout => false
        }
        format.json { render json: {files: [@attachment.to_jq_upload], update_path: lesson_attachment_show_lesson_details_path(@lesson, @attachment)}, status: :created, location: @attachment }
      else
        format.html { render action: "new" }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  def show_lesson_details
    @attachment = Attachment.find(params[:attachment_id])
    render layout: false
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
    params.fetch(:attachment, {}).permit(:file, :description)
  end
end
