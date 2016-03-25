class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:create, :destroy]
  before_action :load_answer, only:[:destroy]
  before_action :check_author, only: [:destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:notice] = 'Answer is added'
    else
      flash[:alert] = "Can't add answer"
      render 'questions/show'
    end
  end

  def destroy
    @answer.destroy
    flash[:notice] = "Your answer was deleted successfully"
    redirect_to @answer.question
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


