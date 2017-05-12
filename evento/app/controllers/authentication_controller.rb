class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def authenticate
    command = AuthenticateUser.call(params[:email], params[:password])

    if command.success?
      render json: {
        auth_token: command.result[:token],
        user: UserSerializer.new(command.result[:user])
      }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end

  def is_authenticated
    @current_user = AuthorizeApiRequest.call(request.headers).result
    if @current_user
      render json: { authenticated: true, user: @current_user }
    else
      render json: { authenticated: false }
    end
  end
end
