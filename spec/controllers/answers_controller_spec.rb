require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  before(:each) do
    request.env["HTTP_REFERER"] = 'where_i_came_from'
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new answer for a question' do
         expect { post :create, answer: attributes_for(:answer), question_id: question, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'saves the new answer for a user' do
        expect { post :create, answer: attributes_for(:answer), question_id: question, format: :js }.to change(@user.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, answer: attributes_for(:answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, answer: { content: nil }, question_id: question, format: :js }.to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, answer: { content: nil }, question_id: question,  format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
      sign_in_user
      context 'Authenticated user deletes his answer' do
        let(:answer) { create(:answer, question: question, user: @user) }
        it 'deletes answer' do
          answer
          expect { delete :destroy, question_id: question, id: answer, format: :js}.to change(Answer, :count).by(-1)
        end

         it 'redirects to question view' do
           delete :destroy, question_id: question, id: answer, format: :js
           expect(response).to render_template :destroy
         end
      end

      context 'Authenticated user deletes foreign answer' do
        it 'does not delete an answer' do
          answer
          expect { delete :destroy, question_id: question, id: answer }.to_not change(Answer, :count)
        end

        it 'redirects to back' do
          delete :destroy, question_id: question, id: answer
          expect(response).to redirect_to 'where_i_came_from'
        end
      end

  end

  describe 'PATCH #update' do
    sign_in_user
    let(:answer) { create(:answer, question: question, user: @user) }
    let(:foreign_answer) { create(:answer, question: question, user: @user) }

    it 'assings the requested answer to @answer' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns the question' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch :update, id: answer, question_id: question, answer: { content: 'new content'}, format: :js
      answer.reload
      expect(answer.content).to eq 'new content'
    end

    it 'renders update template' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(response).to render_template :update
    end

    it 'does not changes answer attributes to invalid params' do
      patch :update, id: answer, question_id: question, answer: { content: ''}, format: :js
      answer.reload
      expect(answer.content).to eq answer.content
    end

    it 'does not changes answer attributes of foreign question' do
      patch :update, id: foreign_answer, question_id: question, answer: { content: 'new content'}, format: :js
      foreign_answer.reload
      expect(foreign_answer.content).to eq foreign_answer.content
    end


  end



end


