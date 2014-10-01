module Api
  class UsersController < ApplicationController
    def create
      @user= User.new(user_params)
      if @user.save
        login(@user)
        render "api/sessions/show" 
      else
        render json: @user.errors, :status => :unprocessable_entity 
      end
    end
    
    def get_info
      @user = current_user
      render "api/sessions/show"
    end

    def update
      @user = User.find(params[:id])
      if @user.update_attributes(update_genre_interest)
        Rails.cache.delete("rec_movies_json_#{@user.id}")
        Rails.cache.delete("genre_interest_final_#{@user.id}")  
        render "api/sessions/show"
      else
        render json: { errors: @user.errors.full_messages }, status: 422
      end
    end

    def destroy
      @user = current_user
      @user.destroy!
      head :ok
    end

    private
    def user_params
      params.require(:user).permit(:email, :password, :name).merge( params.permit(:password))
    end  

    def update_genre_interest
      params.require(:user).permit(:genre0, :genre1, :genre2, :genre3, :genre4,
        :genre5, :genre6, :genre7, :genre8, :genre9, :genre10, :genre11, :genre12,
        :genre13, :genre14, :genre15, :genre16, :genres_saved)      
    end
  end
end