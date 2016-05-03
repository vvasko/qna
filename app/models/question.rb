class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy

  has_many :attachments, as: :attachmentable
  accepts_nested_attributes_for :attachments

  validates :title, :content, presence: true
  validates :user_id, presence: true

end
