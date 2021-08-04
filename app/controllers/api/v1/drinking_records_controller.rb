class Api::V1::DrinkingRecordsController < ApplicationController
  before_action :authenticate_api_v1_user!
  # before_action :set_drinking_record, only: %i[destroy]

  # def index
  #   @drinking_records = current_api_v1_user.drinking_records.order(drinking_date: :asc)
  #   render json: @drinking_records, status: :ok
  # end

  def create
    @drinking_record = current_api_v1_user.drinking_records.build(drinking_record_params)
    if @drinking_record.save
      render json: @drinking_record, status: :ok
    else
      render json: @drinking_record.errors.full_messages, status: :unprocessable_entity
    end
  end

  # def update
  #   @drinking_record.update(drinking_record_params)
  #   if @drinking_record.save
  #     render json: {
  #       data: @drinking_record,
  #       status: :ok,
  #     }
  #   else
  #     render json: {
  #       data: @drinking_record.error,
  #       status: :unprocessable_entity,
  #     }
  #   end
  # end

  # def destroy
  #   @drinking_record.destroy
  #   render json: { status: :ok }
  # end

  private

  def set_drinking_record
    @drinking_record = current_api_v1_user.drinking_records.find(drinkig_date: params[:drinking_date])
  end

  def drinking_record_params
    params.require(:drinking_record).permit(
      :user_id,
      :lemon_sour_id,
      :drinking_date,
      :pure_alcohol_amount,
      :drinking_amount,
    )
  end
end
