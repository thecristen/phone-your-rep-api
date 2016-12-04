require 'test_helper'

class RepsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rep = reps(:one)
  end

  test "should get index" do
    get reps_url, as: :json
    assert_response :success
  end

  test "should create rep" do
    assert_difference('Rep.count') do
      post reps_url, params: { rep: { name: @rep.name, phone: @rep.phone } }, as: :json
    end

    assert_response 201
  end

  test "should show rep" do
    get rep_url(@rep), as: :json
    assert_response :success
  end

  test "should update rep" do
    patch rep_url(@rep), params: { rep: { name: @rep.name, phone: @rep.phone } }, as: :json
    assert_response 200
  end

  test "should destroy rep" do
    assert_difference('Rep.count', -1) do
      delete rep_url(@rep), as: :json
    end

    assert_response 204
  end
end
