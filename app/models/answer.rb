class Answer < ActiveRecord::Base

  include Votable

  belongs_to :user
  belongs_to :question, counter_cache:  true
  has_many :attachments, as: :attachable,  dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :content, :question_id, :user_id,  presence: true

  default_scope { order(best: :desc) }

  def set_best!
    Answer.transaction do
      self.question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end
end
