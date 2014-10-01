module Api
  class SessionsController < ApplicationController
    def create
      @user = User.find_by_credentials(user_params[:email], user_params[:password])

      if @user && login(@user)
        render "show"
      else
        render json: "Login Failed"
      end
    end

    def createauth
      auth = request.env["omniauth.auth"]
      @user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
      if @user && login(@user)
        redirect_to "http://www.moviegenie.net/#users/get_info"
      else
        render json: "Login Failed"
      end
    end  

    def destroy
      logout
      head :ok
    end

    private
    def user_params
      params.require(:session).permit(:email, :password)
    end    
  end
end
