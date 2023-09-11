# frozen_string_literal: true

class ProgramsController < ApplicationController
  before_action :find_id, only: %i[show update destroy]

  def index
    program = Program.all
    if program.present?
      render json: program
    else
      render json: { message: 'No programs exists' }
    end
  end

  def create
    if @current_user.type == 'Instructor'
      program = @current_user.programs.new(set_params)
      if program.save
        render json: program
      else
        render json: { errors: program.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: 'You do not have permission to create a program.' }, status: :unauthorized
    end
  end

  def show
    render json: @program, serializer: ProgramSerializer
  end

  def update
    if @current_user.type == 'Instructor'
      if @program.update(set_params)
        render json: @program
      else
        render json: { errors: @program.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: 'You do not have permission to update this program.' }, status: :unauthorized
    end
  end

  def destroy
    if @current_user.type == 'Instructor'
      if @program.destroy
        render json: { message: 'Deleted successfully' }
      else
        render json: { message: 'Failed to delete the program' }
      end
    else
      render json: { message: 'You do not have permission to delete this program' }, status: :unauthorized
    end
  end

  private

  def set_params
    params.permit(:name, :status, :price, :user_id, :category_id, :image)
  end

  def find_id
    @program = Program.find_by_id(params[:id])
    return if @program

    render json: 'Id not found..'
  end
end
