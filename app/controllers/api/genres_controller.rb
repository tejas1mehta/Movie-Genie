module Api
  class GenresController < ApplicationController
    before_action :require_login, only: [:index, :show]

    def index
      @genres = Genre.all
      render json: @genres
    end

    def show
      @genre = Genre.find(params[:id])
      render :show
    end
  end
end