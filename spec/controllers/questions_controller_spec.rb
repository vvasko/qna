require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  before(:each) do
    request.env["HTTP_REFERER"] = 'where_i_came_from'
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question,2)}
    before { get :index }

    it 'populates array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end

  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assings new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'Builds new Attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new}

    it 'assigns a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'Builds new Attachment for @question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders show new' do
      expect(response).to render_template :new
    end

  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show edit' do
      expect(response).to render_template :edit
    end

  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new question to the database' do
        expect { post :create, question: attributes_for(:question)}.to change(Question, :count).by(1)
      end

      it 'saves the question for a user' do
        expect { post :create, question: attributes_for(:question) }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))

      end
    end

    context 'with invalid attributes' do
      it 'does not saves the new question to the database' do
        expect { post :create, question: attributes_for(:invalid_question)}.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new

      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let(:question) { create :question, user: @user }
    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, id: question, question: {title: 'new title', content: 'new content'},format: :js
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.content).to eq 'new content'

      end

      it 'renders update template' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      before { patch :update, id: question, question: {title: 'new title', content: nil}, format: :js }
      it 'does not changes question attributes' do
        question.reload
        expect(question.title).to_not eq 'new title'
        expect(question.content).to_not eq nil
       end

      it 're-renders update template' do
        expect(response).to render_template :update
      end
    end

  end

  describe 'DELETE #destroy' do
    sign_in_user
    context 'Authenticated user deletes his question' do
      let(:question) { create :question, user: @user }

      it 'deletes question' do
        question
        expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context 'User tries to delete foreign question' do
      it 'does not delete question' do
        question
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end

      it 'redirect to back' do
        delete :destroy, id: question
        expect(response).to redirect_to 'where_i_came_from'
      end
    end
  end

end
