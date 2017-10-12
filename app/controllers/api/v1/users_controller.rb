class Api::V1::UsersController < ApplicationController

  def create
    user = User.new(user_params)
    if user.save
      payload = {user_id: user.id}
      token = issue_token(payload)
      render json: {user: user, jwt: token}
    else
    	render json: {message: "Signin failed! Invalid username or password!"}
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end


  end
