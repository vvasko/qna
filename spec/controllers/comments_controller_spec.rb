require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user) { create(:user) }

  before(:each) do
    request.env["HTTP_REFERER"] = 'where_i_came_from'
  end

  describe 'POST #create' do
    sign_in_user
    let(:question) { create(:question, user: @user) }
    let(:answer) { create(:answer, question: question, user: @user) }

    context 'with valid attributes' do
      it 'saves the comment in the database and assigns it to commentable' do
        expect { post :create, question_id: question.id, comment: attributes_for(:comment), format: :js }.to change(question.comments, :count).by(1)
        expect { post :create, question_id: answer.question_id, answer_id: answer.id, commentable: answer, comment: attributes_for(:comment), format: :js }.to change(answer.comments, :count).by(1)
      end

      it 'assigns comment to user' do
        expect { post :create, question_id: question, commentable: question, comment: attributes_for(:comment), format: :js }.to change(@user.comments, :count).by(1)
        expect { post :create, question_id: answer.question_id, answer_id: answer, commentable: answer, comment: attributes_for(:comment), format: :js }.to change(@user.comments, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, question_id: question, commentable: question, comment: attributes_for(:invalid_comment), format: :js }.to_not change(Comment, :count)
        expect { post :create, question_id: answer.question_id, answer_id: answer, commentable: answer,comment: attributes_for(:invalid_comment), format: :js }.to_not change(Comment, :count)
      end
    end
  end


  describe 'DELETE #destroy' do
    sign_in_user
    let(:question) { create(:question, user: @user) }
    let(:answer) { create(:answer, question: question, user: @user) }

    let!(:answer_comment) { create :comment, commentable: answer, user: @user }
    let!(:question_comment) { create :comment, commentable: question, user: @user }

    let!(:foreign_answer_comment) { create :comment, commentable: answer }
    let!(:foreign_question_comment) { create :comment, commentable: question }

    context 'authorized user' do
      it 'deletes own comment' do
        expect { delete :destroy, id: question_comment, format: :js }.to change(question.comments, :count).by(-1)
        expect { delete :destroy, id: answer_comment, format: :js }.to change(answer.comments, :count).by(-1)
      end

      it 'can not delete foreign comment' do
        expect { delete :destroy, id: foreign_question_comment, format: :js }.to_not change(Comment, :count)
        expect { delete :destroy, id: foreign_answer_comment, format: :js }.to_not change(Comment, :count)
      end
    end

    context 'non-authorized user' do
      before { sign_out @user }
      it 'does not delete others comment' do
        expect { delete :destroy, id: foreign_question_comment, format: :js }.to_not change(Comment, :count)
        expect { delete :destroy, id: foreign_answer_comment, format: :js }.to_not change(Comment, :count)
      end
    end
  end

end
