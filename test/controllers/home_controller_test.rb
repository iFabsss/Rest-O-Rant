require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get home_index_url
    assert_response :success
  end

  test "should get reserve" do
    get home_reserve_url
    assert_response :success
  end

  test "should get confirm" do
    get home_confirm_url
    assert_response :success
  end

  test "should get reservations" do
    get home_reservations_url
    assert_response :success
  end
end
