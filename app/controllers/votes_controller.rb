class VotesController < ApplicationController

    respond_to :json

    before_action :authenticate_user!
    before_action :set_votable, only: [:up, :down, :reset]
    before_action :check_author, only: [:up, :down, :reset]
    before_action :check_vote, only: [:up, :down, :reset]

    def up
      vote!(Vote::TYPE[:up])
      update_rating!
      json_response!
    end

    def down
      vote!(Vote::TYPE[:down])
      update_rating!
      json_response!
    end

    def reset
      unvote!
      update_rating!
      json_response!
    end

  private

    def set_votable
      className = params[:type].to_s.capitalize.constantize
      paramName = params[:type].to_s << '_id'

      @votable = className.find(params[paramName])
    end

    def vote_params
      {user: current_user, votable_id: @votable.id, votable_type: votableType}
    end

    def check_author
      if current_user.is_author?(@votable)
        @votable.errors.add('Permission denied', 'User can not vote for his own items.')
        render json: @votable.errors.full_messages, status: :forbidden
      end
    end

    def check_vote
      current_user.voted_for?(@votable)
    end

    def vote!(value)
      @vote = Vote.new(vote_params.merge!(value: value))
      @vote.save
    end

    def unvote!
      Vote.where(votable: @votable, user_id: current_user.id).delete_all
    end

    def votableType
      @votable.class.name
    end

    def totalRating
      Vote.where(votable_id: @votable.id, votable_type: votableType).sum(:value)
    end

    def update_rating!
      @votable.update_attribute(:rating, totalRating)
      @votable.reload.rating
    end

    def json_response!
      render json: {
          user_vote: @vote.present? ? @vote.value : 0,
          rating: @votable.rating,
      }
    end
end
