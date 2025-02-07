class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  # POST /signup
  def create
    user = User.new(user_params)
    if user.save
      # Only return the user data and a success status.
      render json: { user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end

