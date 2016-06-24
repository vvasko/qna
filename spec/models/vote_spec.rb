require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }
  it { should validate_presence_of :value }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :votable_id }
  it { should validate_inclusion_of(:votable_type).in_array(%w[Question Answer])}

  let(:user) { create :user }
  let(:foreign_user) { create :user }
  let(:question) { create(:question, user: user) }
  let(:foreign_question) { create(:question, user: foreign_user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:foreign_answer) { create(:answer, question: question, user: foreign_user) }


  describe 'for question' do
    it 'vote up' do
      foreign_question.vote!(user, 1)
      expect(foreign_question.total_rating).to eq 1
    end

    it 'vote down' do
      foreign_question.vote!(user, -1)
      expect(foreign_question.total_rating).to eq -1
    end

    it 'unvote' do
      foreign_question.vote!(user, 1)
      foreign_question.unvote(user)
      expect(foreign_question.total_rating).to eq 0
    end

    it 'gives votable type' do
      expect(foreign_question.votable_type).to eq 'Question'
    end

    it 'user can not vote for his own questions' do
      expect(question.can_vote(user)).to be_falsey
    end

    it 'user can vote for foreign questions' do
      expect(foreign_question.can_vote(user)).to be_truthy
    end

    it 'question is voted by user' do
      expect(foreign_question.voted_by(user)).to be_falsey
      foreign_question.vote!(user, 1)
      expect(foreign_question.voted_by(user)).to be_truthy
    end

    it 'updates and returns total rating' do
      foreign_question.vote!(user, 1)
      expect(foreign_question.total_rating).to eq 1
      expect(question.total_rating).to eq 0
    end

  end

  describe 'for answer' do
    it 'vote up' do
      foreign_answer.vote!(user, 1)
      expect(foreign_answer.total_rating).to eq 1
    end

    it 'vote down' do
      foreign_answer.vote!(user, -1)
      expect(foreign_answer.total_rating).to eq -1
    end

    it 'unvote' do
      foreign_answer.vote!(user, 1)
      foreign_answer.unvote(user)
      expect(foreign_answer.total_rating).to eq 0
    end

    it 'gives votable type' do
      expect(foreign_answer.votable_type).to eq 'Answer'
    end

    it 'user can not vote for his own answer' do
      expect(answer.can_vote(user)).to be_falsey
    end

    it 'user can vote for foreign answers' do
      expect(foreign_answer.can_vote(user)).to be_truthy
    end

    it 'answer is voted by user' do
      expect(foreign_answer.voted_by(user)).to be_falsey
      foreign_answer.vote!(user, 1)
      expect(foreign_answer.voted_by(user)).to be_truthy
    end

    it 'updates and returns total rating' do
      foreign_answer.vote!(user, 1)
      expect(foreign_answer.total_rating).to eq 1
      expect(answer.total_rating).to eq 0
    end

  end

end
