class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question, counter_cache:  true
  has_many :attachments, as: :attachmentable
  accepts_nested_attributes_for :attachments

  validates :content, :question_id, :user_id,  presence: true

  default_scope { order(best: :desc) }

  def set_best!
    Answer.transaction do
      self.question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end
end
