module Api
  class MoviesController < ApplicationController
    before_action :require_login, only: [:index, :show]

    def index
      render json: current_user.recommended_movies
    end

    def show
      @movie = Movie.find(params[:id])
      render json: @movie.send_details
    end
  end
end