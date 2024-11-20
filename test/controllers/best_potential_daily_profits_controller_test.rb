require 'test_helper'

class BestPotentialDailyProfitsControllerTest < ActionDispatch::IntegrationTest

  test "daily profits show response is successful when provided a date" do
    get best_potential_daily_profit_url("2024-11-19")
    assert_response :success
    assert_equal 'application/json', response.media_type
  end

  test "triggers bad request when present or future date parameter" do
    get best_potential_daily_profit_url(Date.today.to_s)

    assert_response :bad_request
    json_response = JSON.parse(response.body)
    assert_equal 'Date must be in the past', json_response['error']

    get best_potential_daily_profit_url(Date.tomorrow.to_s)

    assert_response :bad_request
    json_response = JSON.parse(response.body)
    assert_equal 'Date must be in the past', json_response['error']
  end

  test "triggers bad request when malformed date parameter" do
    get best_potential_daily_profit_url('invalid-date')

    assert_response :bad_request
    json_response = JSON.parse(response.body)
    assert_equal 'Invalid date format', json_response['error']
  end
end
