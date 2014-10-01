module Api
  class StudiosController < ApplicationController
    def show
      @studio = Studio.find(params[:id])
      render :show 
    end

    def search
      matched_studios = Studio.search("Studio", "name", search_keyword["keywords"])
      render json: matched_studios
    end

    private
    def search_keyword
      params.require(:studio).permit(:keywords)
    end    
  end
end
