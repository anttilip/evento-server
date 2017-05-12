class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :events]
  skip_before_action :authenticate_request, only: [:index, :show, :create]
  wrap_parameters :user, include: [:name, :email, :password]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # GET /users/1/events
  def events
    if @current_user == @user
      render json: @user.events
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @current_user != @user
      render json: { error: 'Not Authorized' }, status: 401
    elsif @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    if @current_user == @user
      @user.destroy
      render status: 200
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
