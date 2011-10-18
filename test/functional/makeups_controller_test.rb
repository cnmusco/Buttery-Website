require 'test_helper'

class MakeupsControllerTest < ActionController::TestCase
  setup do
    @makeup = makeups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:makeups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create makeup" do
    assert_difference('Makeup.count') do
      post :create, :makeup => @makeup.attributes
    end

    assert_redirected_to makeup_path(assigns(:makeup))
  end

  test "should show makeup" do
    get :show, :id => @makeup.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @makeup.to_param
    assert_response :success
  end

  test "should update makeup" do
    put :update, :id => @makeup.to_param, :makeup => @makeup.attributes
    assert_redirected_to makeup_path(assigns(:makeup))
  end

  test "should destroy makeup" do
    assert_difference('Makeup.count', -1) do
      delete :destroy, :id => @makeup.to_param
    end

    assert_redirected_to makeups_path
  end
end
