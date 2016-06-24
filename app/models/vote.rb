class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, presence: true
  validates :user_id, presence: true
  validates :votable_id, presence: true
  validates :votable_type, inclusion: ['Question', 'Answer']

  validates :user_id, uniqueness: { scope: [:votable_type, :votable_id] }

  TYPE = {:up => 1, :down => -1}

end
