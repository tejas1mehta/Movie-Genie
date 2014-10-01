module Api
  class UserRatingJoinsController < ApplicationController
    before_action :require_login, only: [:create, :update]

    def create
      @new_movie_rating = UserRatingJoin.new(movie_id_param)
      if @new_movie_rating.save
        render json: @new_movie_rating
      else
        render json: @new_movie_rating.errors, :status => :unprocessable_entity 
      end
    end

    def update
      @rated_movie = UserRatingJoin.find(params[:id])
      if @rated_movie && @rated_movie.user_id == current_user.id
        @rated_movie.update_attributes(movie_id_param)
        render json: @rated_movie
      else
        render json: "Could not update"       
      end
    end

    private
    def movie_id_param
      params.require(:user_rating_join).permit(:movie_id, :movie_rating).merge({user_id: current_user.id})
    end
  end
end