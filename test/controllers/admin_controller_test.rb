require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_index_url
    assert_response :success
  end

  test "should get reservations" do
    get admin_reservations_url
    assert_response :success
  end

  test "should get timeslots" do
    get admin_timeslots_url
    assert_response :success
  end

  test "should get tables" do
    get admin_tables_url
    assert_response :success
  end
end
