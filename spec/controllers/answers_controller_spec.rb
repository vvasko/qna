require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer for a question' do
        expect { post :create, answer: attributes_for(:answer), question_id: question }.to change(question.answers, :count).by(1)
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
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'DELETE #destroy' do
      it 'deletes answer' do
        answer
        expect { delete :destroy, question_id: question, id: answer }.to change(Answer, :count).by(-1)
      end
      it 'redirects to question view' do
        delete :destroy, question_id: question, id: answer
        expect(response).to redirect_to question_path(question)
      end
  end

end


