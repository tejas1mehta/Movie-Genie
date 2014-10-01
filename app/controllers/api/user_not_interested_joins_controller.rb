module Api
  class UserNotInterestedJoinsController < ApplicationController
    before_action :require_login, only: [:create, :destroy]

    def create
      @new_not_interested_movie= UserNotInterestedJoin.new(movie_id_param)
      if @new_not_interested_movie.save
        render json: @new_not_interested_movie
      else
        render json: @new_not_interested_movie.errors, :status => :unprocessable_entity 
      end
    end

    def destroy
      @not_interested_movie = UserNotInterestedJoin.find(params[:id])
      if @not_interested_movie && @not_interested_movie.user_id == current_user.id
        @not_interested_movie.destroy!
        render json: @not_interested_movie  
      else
        render json: "Could not remove from not interested list"       
      end
    end

    private
    def movie_id_param
      params.require(:user_not_interested_join).permit(:movie_id).merge({user_id: current_user.id})
    end
  end
end
