class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  before_action :load_attachment, only:[:destroy]
  before_action :load_attachable, only: [:destroy]
  before_action :check_author, only: [:destroy]

  respond_to :js

  def destroy
    respond_with(@attachment.destroy)
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end

  def load_attachable
    @attachable = @attachment.attachable
  end

  def check_author
    unless current_user.is_author?(@attachable)
      flash[:notice] = 'Permission denied.'
      redirect_to :back
    end
  end
end
