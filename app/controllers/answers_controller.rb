class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:create, :destroy]
  before_action :load_answer, only:[:update,:destroy]
  before_action :check_author, only: [:update, :destroy]

  def create
    @answer = @question.answers.create(answer_params.merge!(user: current_user))
    @answer.user = current_user
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
    # flash[:notice] = "Your answer was deleted successfully"
    # redirect_to @answer.question
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:content)
  end

  def check_author
    unless current_user.is_author?(@answer)
      flash[:notice] = 'Permission denied.'
      redirect_to :back
    end
  end
end


