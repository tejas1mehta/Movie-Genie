module Api
  class UserListJoinsController < ApplicationController
    before_action :require_login, only: [:create, :destroy]

    def create
      @new_movie_list = UserListJoin.new(movie_id_param)
      if @new_movie_list.save
        render json: @new_movie_list
      else
        render json: @new_movie_list.errors, :status => :unprocessable_entity 
      end
    end

    def destroy
      @listed_movie = UserListJoin.find(params[:id])
      if @listed_movie && @listed_movie.user_id == current_user.id
        @listed_movie.destroy!
        render json: @listed_movie  
      else
        render json: "Could not remove from list"       
      end
    end

    private
    def movie_id_param
      params.require(:user_list_join).permit(:movie_id).merge({user_id: current_user.id})
    end
  end
end