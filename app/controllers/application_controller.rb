# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include JsonWebToken

  before_action :authenticate_request

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    decoded = jwt_decode(header)
    @current_user = User.find(decoded[:user_id])
  rescue JWT::DecodeError
    render json: { error: 'Invalid token' }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound
    render json: 'No record found..'
  end

  attr_reader :current_user

  def render_404
    render json: { error: 'Invalid URL' }, status: :not_found
  end
end
