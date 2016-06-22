module Votable
  extend ActiveSupport::Concern

   included do
     has_many :votes, as: :votable, dependent: :destroy
   end

  def votable_type
    self.class.name
  end

  def vote!(user, value)
    if can_vote(user) && !voted_by(user)
      @vote = Vote.new({user: user, votable_id: self.id, votable_type: votable_type,value: value})
      @vote.save
      @vote
    end
  end

  def unvote(user)
    if can_vote(user) && voted_by(user, false)
      Vote.where(votable: self, user_id: user.id).delete_all
    end

  end

  def can_vote(user, add_errors = true)
    if user.is_author?(self)
      errors.add('Permission denied', 'User can not vote for his own items.') if add_errors
      return false
    end

    return true

  end

  def voted_by(user, add_errors = true)
    if user.voted_for?(self)
      errors.add('Permission denied', 'User can not vote twice for one item.') if add_errors
      return true
    end

    return false
  end

  def total_rating
    votes.sum(:value)
  end

  def update_rating
    update_attribute(:rating, total_rating)
    reload.rating
  end


end