require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question)}

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

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

  end

  describe 'GET #new' do
    before { get :new}

    it 'assigns a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders show new' do
      expect(response).to render_template :new
    end

  end

  describe 'GET #edit' do
    before { get :edit, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show edit' do
      expect(response).to render_template :edit
    end

  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new question to the database' do
        expect { post :create, question: attributes_for(:question)}.to change(Question, :count).by(1)
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
    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, id: question, question: {title: 'new title', content: 'new content'}
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.content).to eq 'new content'

      end

      it 'redirects to the updated question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(response).to redirect_to question
      end
    end

    context 'invalid attributes' do
      before { patch :update, id: question, question: {title: 'new title', content: nil} }
      it 'does not changes question attributes' do
        question.reload
        expect(question.title).to eq 'My String'
        expect(question.content).to eq 'My Text'
       end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end

  end

  describe 'DELETE #destroy' do
    before {question}
    it 'deletes question' do
      expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
    end

    it 'redirects to index view' do
      delete :destroy, id: question
      expect(response).to redirect_to question

    end
  end

end