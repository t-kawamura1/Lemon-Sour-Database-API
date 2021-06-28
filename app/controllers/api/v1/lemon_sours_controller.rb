class Api::V1::LemonSoursController < ApplicationController
  before_action :set_lemon_sour, only: [:show]
  before_action :set_lemon_sours, only: [:index, :search_by_manufacturer]

  def show
    render json: {
      status: 200,
      data: @lemon_sour,
    }
  end

  def index
    render json: {
      status: 200,
      data: @lemon_sours,
    }
  end

  def create
    lemon_sour = LemonSour.new(lemon_sour_params)
    if lemon_sour.save
      render json: {
        status: 200,
        data: lemon_sour,
      }
    else
      render json: {
        status: 'ERROR',
        data: lemon_sour.error,
      }
    end
  end

  def search_by_manufacturer
    if params[:manufacturer] == "すべて"
      return @lemon_sours if @lemon_sours.initial_display?
      @lemon_sours = LemonSour.order(updated_at: :desc)
    else
      @lemon_sours = @lemon_sours.where("manufacturer = ?", params[:manufacturer])
    end
    render json: {
      status: 200,
      data: @lemon_sours,
    }
  end

  private

  def set_lemon_sour
    @lemon_sour = LemonSour.find(params[:id])
  end

  def set_lemon_sours
    @lemon_sours = LemonSour.order(updated_at: :desc)
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
end
