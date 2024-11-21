require "test_helper"

class MarketPriceTest < ActiveSupport::TestCase
  setup do
    @date = Date.current
    @default_value = 100.10
  end

  test "by_date scope returns prices within the same day, even at the boundaries" do
    market_price_lower_boundary = MarketPrice.create(time: @date.beginning_of_day, value: @default_value)
    market_price_inside_boundary = MarketPrice.create(time: @date.beginning_of_day + 3.hours, value: @default_value)
    market_price_upper_boundary = MarketPrice.create(time: @date.end_of_day, value: @default_value)

    market_price_outside_boundary = MarketPrice.create(time: @date.yesterday, value: @default_value)

    results = MarketPrice.by_date(@date)

    assert_includes results, market_price_lower_boundary
    assert_includes results, market_price_inside_boundary
    assert_includes results, market_price_upper_boundary
    assert_not_includes results, market_price_outside_boundary
  end

  test "by_date scope returns empty collection for date with no prices" do
    assert_equal [], MarketPrice.by_date(Date.current + 1.year)
  end

  test "2 prices cannot have the same time" do
    time = Time.current
    first_price = MarketPrice.create(time: time, value: @default_value)
    assert first_price.persisted?

    duplicate_price = MarketPrice.new(time: time, value: @default_value)
    assert_not duplicate_price.valid?
  end

  test "value must be present" do
    market_price = MarketPrice.new(value: nil)
    assert_not market_price.valid?
  end
end
