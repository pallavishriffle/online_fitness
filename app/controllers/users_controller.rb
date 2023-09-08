# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[create user_login]

  def index
    user = User.all
    if user.empty?
      render json: { message: 'No data found...' }
    else
      render json: user
    end
  end

  def create
    user = User.new(set_params)
    if user.save
      render json: { message: 'User Created', data: user }
    else
      render json: { errors: user.errors.full_messages }
    end
  end

  def user_login
    if (user = User.find_by(email: params[:email], password_digest: params[:password_digest]))
      token = jwt_encode(user_id: user.id)
      render json: { message: 'Logged In Successfully..', token: token }
    else
      render json: { error: 'Please Check your Email And Password.....' }
    end
  end

  def update
    user = User.find(@current_user.id)
    if user.update(update_params)
      render json: { message: 'Updated successfully......', data: user }
    else
      render json: { errors: user.errors.full_messages }
    end
  end

  def destroy
    user = User.destroy(@current_user.id)
    render json: { message: 'Deleted successfully', data: user }
  end

  def show
    render json: @current_user
  end

  private

  def set_params
    params.permit(:name, :email, :password_digest, :mobile, :type)
  end

  def update_params
    params.permit(:name, :email, :password_digest, :mobile, :type)
  end
end
