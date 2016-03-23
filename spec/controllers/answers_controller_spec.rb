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
         expect { post :create, answer: attributes_for(:answer), question_id: question }.to change(question.answers, :count).by(1)
      end

      it 'saves the new answer for a user' do
        expect { post :create, answer: attributes_for(:answer), question_id: question }.to change(@user.answers, :count).by(1)
      end

      it 'redirects to question view' do
        post :create, answer: attributes_for(:answer), question_id: question
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, answer: { content: nil }, question_id: question }.to_not change(Answer, :count)
      end
      it 'redirects to question' do
        post :create, answer: { content: nil }, question_id: question
        expect(response).to render_template :show
      end
    end
  end

  describe 'DELETE #destroy' do
      sign_in_user
      context 'Authenticated user deletes his answer' do
        let(:answer) { create(:answer, question: question, user: @user) }
        it 'deletes answer' do
          answer
          expect { delete :destroy, question_id: question, id: answer }.to change(Answer, :count).by(-1)
        end

         it 'redirects to question view' do
           delete :destroy, question_id: question, id: answer
           expect(response).to redirect_to question_path(question)
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



end


