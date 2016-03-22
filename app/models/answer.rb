class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question, :counter_cache => true

  validates :content, :question_id, presence: true
  validates :user_id, presence: true
end
