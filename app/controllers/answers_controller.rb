class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:create, :destroy]
  before_action :load_answer, only:[:update,:destroy, :set_best]
  before_action :check_author, only: [:update, :destroy, :set_best ]

  respond_to :js

  def create
    respond_with (@answer = @question.answers.create(answer_params.merge!(user: current_user)))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def set_best
    @answer.set_best! if current_user.is_author?(@question)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:content, attachments_attributes: [:file])
  end

  def check_author
    unless current_user.is_author?(@answer)
      flash[:notice] = 'Permission denied.'
      redirect_to :back
    end
  end

end


