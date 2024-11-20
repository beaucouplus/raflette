class BestPotentialDailyProfit
  attr_reader :market_prices

  def initialize(market_prices = [])
    @market_prices = market_prices
  end

  TON = 100

  def find
    return nil if market_prices.size < 2

    min_price = Float::INFINITY
    max_profit = 0

    market_prices.each do |current_price|
      if current_price.value < min_price
        min_price = current_price.value
      end

      current_profit = current_price.value - min_price

      if current_profit > max_profit
        max_profit = current_profit
      end
    end

    (TON * max_profit).to_i
  end
end
