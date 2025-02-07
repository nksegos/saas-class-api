class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  # POST /signup
  def create
    user = User.new(user_params)
    if user.save
      token = encode_token(user_id: user.id)
      render json: { token: token, user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
