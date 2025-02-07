class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')
      payload = decoded[0]
      user = User.find(payload['user_id'])
      # Convert the token's token_version to integer before comparing.
      if user.token_version != payload['token_version'].to_i
        render json: { error: 'Token has expired or user logged out' }, status: :unauthorized and return
      end
      @current_user = user
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def encode_token(payload)
    JWT.encode(payload, Rails.application.secret_key_base, 'HS256')
  end
end

