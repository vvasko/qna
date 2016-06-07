require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }

  sign_in_user
  let(:question) { create(:question, user: @user) }
  let(:answer) { create(:answer, question: question, user: @user) }
  let(:foreign_question) { create(:question, user: user) }
  let(:foreign_answer)  { create(:answer, question: foreign_question, user: user) }

  before(:each) do
    request.env["HTTP_REFERER"] = 'where_i_came_from'
  end

  describe 'POST #up' do
    context 'Authenticated user votes for foreign item not voted by him yet =>' do
      it 'adds vote for a  question' do
        expect { post :up, question_id: foreign_question, type: :question, format: :js }.to change(foreign_question.votes, :count).by(1)
      end

      it 'adds vote for an answer' do
        expect { post :up, question_id: foreign_question, answer_id: foreign_answer, type: :answer, format: :js }.to change(foreign_answer.votes, :count).by(1)
      end

      it 'saves the new vote for user' do
        expect { post :up, question_id: foreign_question, type: :question, format: :js }.to change(@user.votes, :count).by(1)
        expect { post :up, question_id: foreign_question, answer_id: foreign_answer, type: :answer, format: :js }.to change(@user.votes, :count).by(1)
      end

      it 'changes rating by 1' do
        post :up, question_id: foreign_question, type: :question, format: :js
        foreign_question.reload
        expect(foreign_question.rating).to eq 1

        post :up, question_id: foreign_question, answer_id: foreign_answer, type: :answer, format: :js
        foreign_answer.reload
        expect(foreign_answer.rating).to eq 1
      end

    end

    context 'Authenticated user votes for foreign item voted by him before =>' do
      let!(:q_vote) {create(:vote, user: @user, votable_id: foreign_question.id, votable_type: :Question, value: 1)}
      let!(:a_vote) {create(:vote, user: @user, votable_id: foreign_answer.id, votable_type: :Answer, value: 1)}

      it 'does not add vote for a question' do
        expect { post :up, question_id: foreign_question, type: :question, format: :js }.to_not change(foreign_question.votes, :count)
      end

      it 'does not add vote for an answer' do
        expect { post :up, question_id: foreign_question, answer_id: foreign_answer, type: :answer, format: :js }.to_not change(foreign_question.votes, :count)
      end

      it 'does not save the new vote for user' do
        expect { post :up, question_id: foreign_question, type: :question, format: :js }.to_not change(@user.votes, :count)
        expect { post :up, question_id: foreign_question, answer_id: foreign_answer, type: :answer, format: :js }.to_not change(@user.votes, :count)
      end

      it 'does not change rating' do
        post :up, question_id: foreign_question, type: :question, format: :js
        foreign_question.reload
        expect(foreign_question.rating).to eq 1

        post :up, question_id: foreign_question, answer_id: foreign_answer, type: :answer, format: :js
        foreign_answer.reload
        expect(foreign_answer.rating).to eq 1
      end
    end

    context 'Authenticated user votes for his question =>' do
      it 'does not add vote for a question' do
        expect { post :up, question_id: question, type: :question, format: :js }.to_not change(question.votes, :count)
      end

      it 'does not add vote for an answer' do
        expect { post :up, question_id: question, answer_id: answer, type: :answer, format: :js }.to_not change(answer.votes, :count)
      end

      it 'does not save the new vote for user' do
        expect { post :up, question_id: question, type: :question, format: :js }.to_not change(@user.votes, :count)
        expect { post :up, question_id: question,  answer_id: answer, type: :answer, format: :js }.to_not change(@user.votes, :count)
      end
    end
  end


  describe 'POST #down' do
    context 'Authenticated user votes for foreign item not voted by him yet =>' do
      it 'adds vote for a  question' do
        expect { post :down, question_id: foreign_question, type: :question, format: :js }.to change(foreign_question.votes, :count).by(1)
      end

      it 'adds vote for an answer' do
        expect { post :down, question_id: foreign_question, answer_id: foreign_answer, type: :answer, format: :js }.to change(foreign_answer.votes, :count).by(1)
      end

      it 'saves the new vote for user' do
        expect { post :down, question_id: foreign_question, type: :question, format: :js }.to change(@user.votes, :count).by(1)
        expect { post :down, question_id: foreign_question, answer_id: foreign_answer, type: :answer, format: :js }.to change(@user.votes, :count).by(1)
      end

      it 'changes rating by -1' do
        post :down, question_id: foreign_question, type: :question, format: :js
        foreign_question.reload
        expect(foreign_question.rating).to eq -1

        post :down, question_id: foreign_question, answer_id: foreign_answer, type: :answer, format: :js
        foreign_answer.reload
        expect(foreign_answer.rating).to eq -1
      end

    end

    context 'Authenticated user votes for foreign item voted by him before =>' do
      let!(:q_vote) {create(:vote, user: @user, votable_id: foreign_question.id, votable_type: :Question, value: -1)}
      let!(:a_vote) {create(:vote, user: @user, votable_id: foreign_answer.id, votable_type: :Answer, value: -1)}

      it 'does not add vote for a question' do
        expect { post :down, question_id: foreign_question, type: :question, format: :js }.to_not change(foreign_question.votes, :count)
      end

      it 'does not add vote for an answer' do
        expect { post :down, question_id: foreign_question, answer_id: foreign_answer, type: :answer, format: :js }.to_not change(foreign_question.votes, :count)
      end

      it 'does not save the new vote for user' do
        expect { post :down, question_id: foreign_question, type: :question, format: :js }.to_not change(@user.votes, :count)
        expect { post :down, question_id: foreign_question, answer_id: foreign_answer, type: :answer, format: :js }.to_not change(@user.votes, :count)
      end

      it 'does not change rating' do
        post :down, question_id: foreign_question, type: :question, format: :js
        foreign_question.reload
        expect(foreign_question.rating).to eq -1

        post :down, question_id: foreign_question, answer_id: foreign_answer, type: :answer, format: :js
        foreign_answer.reload
        expect(foreign_answer.rating).to eq -1
      end
    end

    context 'Authenticated user votes for his question =>' do
      it 'does not add vote for a question' do
        expect { post :down, question_id: question, type: :question, format: :js }.to_not change(question.votes, :count)
      end

      it 'does not add vote for an answer' do
        expect { post :down, question_id: question, answer_id: answer, type: :answer, format: :js }.to_not change(answer.votes, :count)
      end

      it 'does not save the new vote for user' do
        expect { post :down, question_id: question, type: :question, format: :js }.to_not change(@user.votes, :count)
        expect { post :down, question_id: question,  answer_id: answer, type: :answer, format: :js }.to_not change(@user.votes, :count)
      end
    end

  end

  describe 'POST #reset' do
    context 'Authenticated user resets his vote for foreign item =>' do
      let!(:q_vote) {create(:vote, user: @user, votable_id: foreign_question.id, votable_type: :Question, value: 1)}
      let!(:a_vote) {create(:vote, user: @user, votable_id: foreign_answer.id, votable_type: :Answer, value: 1)}

      it 'resets vote for a question' do
        expect { post :reset, question_id: foreign_question, type: :question, format: :js }.to change(foreign_question.votes, :count).by(-1)
      end

      it 'resets vote for an answer' do
        expect { post :reset, question_id: foreign_question, answer_id: foreign_answer, type: :answer, format: :js }.to change(foreign_answer.votes, :count).by(-1)
      end

      it 'removes the vote for user' do
        expect { post :reset, question_id: foreign_question, type: :question, format: :js }.to change(@user.votes, :count).by(-1)
        expect { post :reset, question_id: foreign_question, answer_id: foreign_answer, type: :answer, format: :js }.to change(@user.votes, :count).by(-1)
      end

      it 'changes rating by -1' do
        post :reset, question_id: foreign_question, type: :question, format: :js
        foreign_question.reload
        expect(foreign_question.rating).to eq 0

        post :reset, question_id: foreign_question, answer_id: foreign_answer, type: :answer, format: :js
        foreign_answer.reload
        expect(foreign_answer.rating).to eq 0
      end

    end

    context "Authenticated user resets the vote for foreign item he didn't vote for =>" do
      let!(:q_vote) {create(:vote, user: user, votable_id: foreign_question.id, votable_type: :Question, value: 1)}
      let!(:a_vote) {create(:vote, user: user, votable_id: foreign_answer.id, votable_type: :Answer, value: 1)}

      it 'does not remove vote for a question' do
        expect { post :reset, question_id: foreign_question, type: :question, format: :js }.to_not change(foreign_question.votes, :count)
      end

      it 'does not remove vote for an answer' do
        expect { post :reset, question_id: foreign_question, answer_id: foreign_answer, type: :answer, format: :js }.to_not change(foreign_question.votes, :count)
      end

      it 'does not remove the  vote for user' do
        expect { post :reset, question_id: foreign_question, type: :question, format: :js }.to_not change(@user.votes, :count)
        expect { post :reset, question_id: foreign_question, answer_id: foreign_answer, type: :answer, format: :js }.to_not change(@user.votes, :count)
      end

      it 'does not change rating' do
        post :reset, question_id: foreign_question, type: :question, format: :js
        foreign_question.reload
        expect(foreign_question.rating).to eq 1

        post :reset, question_id: foreign_question, answer_id: foreign_answer, type: :answer, format: :js
        foreign_answer.reload
        expect(foreign_answer.rating).to eq 1
      end
    end

    context 'Authenticated user resets vote for his question =>' do
      let!(:q_vote) {create(:vote, user: user, votable_id: foreign_question.id, votable_type: :Question, value: 1)}
      let!(:a_vote) {create(:vote, user: user, votable_id: foreign_answer.id, votable_type: :Answer, value: 1)}

      it 'does not remove vote for a question' do
        expect { post :reset, question_id: question, type: :question, format: :js }.to_not change(question.votes, :count)
      end

      it 'does not remove vote for an answer' do
        expect { post :reset, question_id: question, answer_id: answer, type: :answer, format: :js }.to_not change(answer.votes, :count)
      end

      it 'does not remove the new vote for user' do
        expect { post :reset, question_id: question, type: :question, format: :js }.to_not change(@user.votes, :count)
        expect { post :reset, question_id: question,  answer_id: answer, type: :answer, format: :js }.to_not change(@user.votes, :count)
      end
    end

  end



end
