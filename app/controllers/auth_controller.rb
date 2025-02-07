class AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [:login]

  # POST /auth/login
  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = encode_token(user_id: user.id)
      render json: { token: token, user: user }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  # GET /auth/logout
  def logout
    # For stateless JWT, logout is typically handled client side
    render json: { message: 'Logged out' }
  end
end
