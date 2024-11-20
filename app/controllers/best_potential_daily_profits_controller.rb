class BestPotentialDailyProfitsController < ApplicationController

  before_action :set_and_validate_date

  def show
    prices = MarketPrice.by_date(@date).order(time: :asc)
    best_potential_profit = BestPotentialDailyProfit.new(prices).find

    render json: best_potential_profit
  end

  private

  def set_and_validate_date
    begin
      @date = params[:id]&.to_date

      if @date&.today? || @date&.future?
        render json: { error: 'Date must be in the past' }, status: :bad_request
      end
    rescue ArgumentError
      render json: { error: 'Invalid date format' }, status: :bad_request
    end
  end
end
