class AnswersController < ApplicationController

  before_action :load_question, only: [:create, :destroy]
  before_action :load_answer, only:[:destroy]

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      flash[:notice] = 'Answer is added'
      redirect_to @question
    else
      flash[:alert] = "Can't add answer"
      render 'questions/show'
    end
  end

  def destroy
    @answer.destroy
    flash[:notice] = "Your answer was deleted successfully"
    redirect_to @question
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
end


