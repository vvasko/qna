class VotesController < ApplicationController

    respond_to :json

    before_action :authenticate_user!
    before_action :set_votable, only: [:up, :down, :reset]

    def up
      @vote = @votable.vote!(current_user, Vote::TYPE[:up])
      json_response
    end

    def down
      @vote = @votable.vote!(current_user, Vote::TYPE[:down])
      json_response
    end

    def reset
      @votable.unvote(current_user)
      json_response
    end

  private

    def set_votable
      className = params[:type].to_s.capitalize.constantize
      paramName = "#{params[:type].to_s }_id"

      @votable = className.find(params[paramName])
    end

    def json_response
      if @votable.errors.present?
        respond_with(@votable)
      else
        render json: {
          user_vote: @vote.present? ? @vote.value : 0,
          rating: @votable.rating,
        }
      end
    end
end
