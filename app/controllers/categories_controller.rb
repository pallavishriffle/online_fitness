# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :find_id, except: %i[index create]

  def index
    category = Category.all
    if category.present?
      render json: category
    else
      render json: { message: 'There are no categories available..' }
    end
  end

  def create
    if @current_user.type == 'Instructor'
      category = @current_user.categories.new(set_params)
      if category.save
        render json: category
      else
        render json: { error: category.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Only instructors can create categories' }, status: :unauthorized
    end
  end

  def update
    if @current_user.type == 'Instructor'
      if @category.update(set_params)
        render json: { message: 'Updated successfully', data: @category }
      else
        render json: { error: @category.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Only instructors can update categories' }, status: :unauthorized
    end
  end

  def destroy
    if @current_user.type == 'Instructor'
      if @category.destroy
        render json: { message: 'Deleted successfully', data: @category }
      else
        render json: { message: 'No such data exists to be deleted' }
      end
    else
      render json: { message: 'Only instructors can delete categories' }, status: :unauthorized
    end
  end

  def show
    render json: @category, serializer: CategorySerializer
  end

  private

  def set_params
    params.permit(:category_name)
  end

  def find_id
    @category = Category.find_by_id(params[:id])
    return if @category

    render json: 'Id not found..'
  end
end
