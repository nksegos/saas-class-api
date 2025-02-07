class AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [:login]

  # POST /auth/login
  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = encode_token(user_id: user.id, token_version: user.token_version)
      render json: { token: token, user: user }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  # GET /auth/logout
  def logout
    current_user.update(token_version: current_user.token_version + 1)
    render json: { message: 'Logged out' }
  end
end

