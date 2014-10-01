module Api
  class CastsController < ApplicationController
    def show
      @cast = Cast.find(params[:id])
      render :show    
    end

    def search
      matched_casts = Cast.search("Cast", "name", search_keyword["keywords"])
      render json: matched_casts
    end

    private
    def search_keyword
      params.require(:cast).permit(:keywords)
    end
  end
end