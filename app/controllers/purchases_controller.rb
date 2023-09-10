# frozen_string_literal: true

class PurchasesController < ApplicationController
  before_action :find_id, only: %i[show update destroy]

  def index
    purchase = Purchase.all
    if purchase.empty?
      render json: { message: 'No data found...' }
    else
      render json: purchase
    end
  end

  def create
    purchase = @current_user.purchases.new(set_params)
    program = Program.find_by(status: 'active', id: purchase.program_id)

    if program
      purchase.status = 'started'

      if purchase.save
        render json: purchase, status: :ok
      else
        render json: { error: purchase.errors.full_messages }
      end
    else
      render json: { message: 'Id not found' }
    end
  end

  def update
    if @current_user.type == 'Instructor'
      if @purchase.status == 'completed'
        render json: { message: 'Program is already completed....' }
      else
        @purchase.update(status: 'completed')
        render json: { message: 'Program has been marked as completed....' }
      end
    else
      render json: { message: 'You do not update this purchase.' }, status: :unauthorized
    end
  end

  def show
    render json: @purchase, serializer: PurchaseSerializer
  end

  def destroy
    if @purchase.destroy
      render json: { message: 'Purchase has been deleted.... ' }
    else
      render json: { message: 'Purchase not deleted' }
    end
  end

  private

  def set_params
    params.permit(:program_id, :customer_name, :mobile)
  end

  def find_id
    @purchase = Purchase.find_by_id(params[:id])
    return if @purchase

    render json: 'Id not found..'
  end
end
