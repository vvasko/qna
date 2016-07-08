class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :user_id,  :commentable_id,:commentable_type, :content, presence: true
  validates :commentable_type, inclusion: ['Question', 'Answer']

end
