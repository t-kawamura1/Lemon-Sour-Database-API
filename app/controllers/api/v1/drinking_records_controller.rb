class Api::V1::DrinkingRecordsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def show
    get_drinking_records_by_date_and_amount_of_pure_alcohol
    @records_of_dates_and_sour_name = current_api_v1_user.drinking_records.dates_and_sour_name
    render json: [
      @records_of_safety,
      @records_of_warning,
      @records_of_dagerous,
      @records_of_dates_and_sour_name,
    ],
           status: :ok
  end

  def amounts_by_month
    @drinking_records_by_month = current_api_v1_user.drinking_records.sum_amouts_by_year_month
    render json: @drinking_records_by_month, status: :ok
  end

  def create
    @drinking_record = current_api_v1_user.drinking_records.build(drinking_record_params)
    if @drinking_record.save
      render json: @drinking_record, status: :ok
    else
      render json: @drinking_record.errors.full_messages, status: :unprocessable_entity
    end
  end

  def delete
    @drinking_records = current_api_v1_user.drinking_records.where("drinking_date = ?", params[:drinking_date])
    if @drinking_records != []
      @drinking_records.destroy_all
      get_drinking_records_by_date_and_amount_of_pure_alcohol
      render json: [
        @records_of_safety,
        @records_of_warning,
        @records_of_dagerous,
      ], status: :ok
    else
      render json: { error_message: "該当する記録がありません" }, status: :not_found
    end
  end

  private

  SAFETY_AMOUNT = 20
  WARNING_AMOUNT = 40

  def get_drinking_records_by_date_and_amount_of_pure_alcohol
    @records_of_safety = current_api_v1_user.drinking_records.pure_alcohol_amount_less_than(SAFETY_AMOUNT)
    @records_of_warning = current_api_v1_user.drinking_records.pure_alcohol_amount_between(SAFETY_AMOUNT, WARNING_AMOUNT)
    @records_of_dagerous = current_api_v1_user.drinking_records.pure_alcohol_amount_or_more(WARNING_AMOUNT)
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
