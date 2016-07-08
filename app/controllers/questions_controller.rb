class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :check_author, only: [:update, :destroy]
  before_action :build_answer, only: :show
  after_action :publish_question, only: :create

  def index
     respond_with(@questions = (user_signed_in? ? Question.includes(:votes) : Question.all))
  end

  def show
    respond_with @question
  end

  def new
    respond_with (@question = Question.new)
  end

  def edit
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user: current_user)))
  end

  def update
    @question.update(question_params)
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :content, attachments_attributes: [:file])
  end

  def check_author
    unless current_user.is_author?(@question)
      flash[:notice] = 'Permission denied.'
      redirect_to :back
    end
  end

  def publish_question
    PrivatePub.publish_to '/questions', question: @question.to_json if @question.valid?
  end

  def build_answer
    @answer = @question.answers.build
  end

end
