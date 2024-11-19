require 'test_helper'

class MarketPricesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @date = Date.parse("2024-11-19")
  end

  test "index renders market prices for a specific date as JSON, ordered by time ASC" do
    get market_prices_url, params: { date: @date }
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal 2, json_response.size
    assert_equal market_prices(:one).time, json_response.first["time"]
    assert_equal market_prices(:two).time, json_response.last["time"]
  end

  test "handles no date parameter provided" do
    get market_prices_url

    assert_response :bad_request
    json_response = JSON.parse(response.body)
    assert_equal 'Date parameter is required', json_response['error']
  end

  test "handles empty date parameter" do
    get market_prices_url, params: { date: '' }

    assert_response :bad_request
    json_response = JSON.parse(response.body)
    assert_equal 'Date parameter is required', json_response['error']
  end

  test "handles malformed date parameter" do
    get market_prices_url, params: { date: 'invalid-date' }

    assert_response :bad_request
    json_response = JSON.parse(response.body)
    assert_equal 'Invalid date format', json_response['error']
  end
end
