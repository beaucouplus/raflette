class MarketPricesController < ApplicationController
  before_action :set_and_validate_date

  def index
    prices = MarketPrice.by_date(@date).order(time: :asc)
    render json: prices
  end

  private

  def set_and_validate_date
    begin
      @date = params[:date]&.to_date
      if @date.blank?
        render json: { error: 'Date parameter is required' }, status: :bad_request
      end
    rescue ArgumentError
      render json: { error: 'Invalid date format' }, status: :bad_request
    end
  end
end
