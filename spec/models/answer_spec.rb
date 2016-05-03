require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :content }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }
  it { should belong_to :question }
  it { should belong_to :user }

  describe 'set_best!' do
    let!(:question) { create :question }
    let!(:answer) { create :answer, question: question }
    let!(:another_answer) { create :answer, question: question, best: true }

    it 'sets answer as best' do
      answer.set_best!
      answer.reload
      expect(answer.best?).to be_truthy
    end

    it 'sets all other answers of question to false' do
      answer.set_best!
      another_answer.reload
      expect(another_answer.best?).to be_falsey
    end
  end
end
