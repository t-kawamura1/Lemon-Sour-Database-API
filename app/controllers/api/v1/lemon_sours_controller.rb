class Api::V1::LemonSoursController < ApplicationController
  before_action :set_lemon_sour, only: %i(show)

  def show
    render json: @lemon_sour, status: :ok
  end

  def index
    @lemon_sours = LemonSour.order(updated_at: :desc)
    render json: @lemon_sours, status: :ok
  end

  # def create
  #   lemon_sour = LemonSour.new(lemon_sour_params)
  #   if lemon_sour.save
  #     render json: {
  #       status: 200,
  #       data: lemon_sour,
  #     }
  #   else
  #     render json: {
  #       status: 'ERROR',
  #       data: lemon_sour.errors,
  #     }
  #   end
  # end

  def search_by
    lemon_sours = LemonSour.displayed_based_on(search_sours_params)
    render json: lemon_sours, status: :ok
  end

  private

  def set_lemon_sour
    @lemon_sour = LemonSour.find(params[:id])
  end

  def lemon_sour_params
    params.require(:lemon_sour).permit(
      :name,
      :manufacturer,
      :calories,
      :alcohol_content,
      :pure_alcohol,
      :fruit_juice,
      :zero_sugar,
      :zero_sweetener,
      :sour_image,
    )
  end

  def search_sours_params
    params.permit(
      :manufacturer,
      :ingredient,
      :order,
    )
  end
end
