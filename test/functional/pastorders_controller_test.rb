require 'test_helper'

class PastordersControllerTest < ActionController::TestCase
  setup do
    @pastorder = pastorders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pastorders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pastorder" do
    assert_difference('Pastorder.count') do
      post :create, :pastorder => @pastorder.attributes
    end

    assert_redirected_to pastorder_path(assigns(:pastorder))
  end

  test "should show pastorder" do
    get :show, :id => @pastorder.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @pastorder.to_param
    assert_response :success
  end

  test "should update pastorder" do
    put :update, :id => @pastorder.to_param, :pastorder => @pastorder.attributes
    assert_redirected_to pastorder_path(assigns(:pastorder))
  end

  test "should destroy pastorder" do
    assert_difference('Pastorder.count', -1) do
      delete :destroy, :id => @pastorder.to_param
    end

    assert_redirected_to pastorders_path
  end
end
