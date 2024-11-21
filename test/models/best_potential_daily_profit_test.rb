require "test_helper"

class BestPotentialDailyProfitTest < ActiveSupport::TestCase
  test "it returns the maximum potential profit" do
    prices = [
      MarketPrice.new(value: 100.25),
      MarketPrice.new(value: 100.29),
      MarketPrice.new(value: 100.29),
      MarketPrice.new(value: 100.29)
    ]

    potential_profit = BestPotentialDailyProfit.new(prices).find
    assert_equal 4, potential_profit
  end

  test "it returns the maximum potential profit even in a complex setup" do
    prices = [
      MarketPrice.new(value: 100.29),
      MarketPrice.new(value: 100.28),
      MarketPrice.new(value: 100.25),
      MarketPrice.new(value: 100.27),
      MarketPrice.new(value: 100.35),
      MarketPrice.new(value: 100.24)
    ]

    potential_profit = BestPotentialDailyProfit.new(prices).find
    assert_equal 10, potential_profit
  end

  test "it returns 0 if there is no profit possible" do
    prices = [
      MarketPrice.new(value: 100.29),
      MarketPrice.new(value: 100.25)
    ]

    potential_profit = BestPotentialDailyProfit.new(prices).find
    assert_equal 0, potential_profit
  end

  test "it returns nil if prices data does not enable making trades" do
    potential_profit = BestPotentialDailyProfit.new([]).find
    assert_nil potential_profit
  end
end
