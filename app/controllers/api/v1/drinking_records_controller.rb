class Api::V1::DrinkigRecords_Controller < ApplicationController
  before_action :authenticate_user!
  before_action :set_drinking_record, only: %s[update destroy]

  # def show
  #   render json: drinking_record, status: :ok
  # end

  def index
    @drinking_records = current_user.drinking_record.order(drinking_date: :asc)
    render json: @drinking_records, status: :ok
  end

  def create
    @drinkig_record = current_user.drinking_record.build(drinkig_record_params)
    if drinkig_record.save
      render json: {
        status: :ok,
        data: @drinkig_record,
      }
    else
      render json: {
        status: :unprocessable_entity,
        data: @drinkig_record.error,
      }
    end
  end

  def update
    @drinking_record.update(drinking_record_params)
    if drinking_record.save
      render json: {
        status: :ok,
        data: @drinking_record,
      }
    else
      render json: {
        status: :unprocessable_entity,
        data: @drinking_record.error,
      }
    end
  end

  def destroy
    @drinking_record.destroy
    render json: {
      status: :ok
    }
  end

  private

  def set_drinking_record
    @drinking_record = current_user.drinking_record.find(drinkig_date: params[:drinking_date])
  end

  def drinking_record_params
    params.require(:drinking_record).permit(
      :user_id,
      :lemon_sour_id,
      :drinkin_date,
      :pure_alcohol_amount,
      :drinking_amount,
    )
  end
end
