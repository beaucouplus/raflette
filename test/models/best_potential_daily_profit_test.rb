require "test_helper"

class BestPotentialDailyProfitTest < ActiveSupport::TestCase
  setup do
    @two_days_ago = 2.days.ago.at_beginning_of_day
  end

  test "it returns the maximum potential profit" do
    prices = [
      MarketPrice.new(time: @two_days_ago, value: 100.25 ),
      MarketPrice.new(time: @two_days_ago.change(hours: 2, minutes: 25), value: 100.29 ),
      MarketPrice.new(time: @two_days_ago.change(hours: 2, minutes: 28), value: 100.29 ),
      MarketPrice.new(time: @two_days_ago.change(hours: 2, minutes: 29), value: 100.29 ),
    ]

    potential_profit = BestPotentialDailyProfit.new(prices).find
    assert_equal 4, potential_profit
  end

  test "it returns 0 if there is no profit possible" do
    prices = [
      MarketPrice.new(time: @two_days_ago, value: 100.29 ),
      MarketPrice.new(time: @two_days_ago.change(hours: 2, minutes: 25), value: 100.25 )
    ]

    potential_profit = BestPotentialDailyProfit.new(prices).find
    assert_equal 0, potential_profit
  end

  test "it returns nil if prices data does not enable making trades" do
    potential_profit = BestPotentialDailyProfit.new([]).find
    assert_nil potential_profit
  end
end
