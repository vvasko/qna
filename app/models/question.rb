class Question < ActiveRecord::Base

  include Votable

  belongs_to :user
  has_many :answers, dependent: :destroy

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :title, :content, presence: true
  validates :user_id, presence: true


end
