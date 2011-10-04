require 'test_helper'

class FoodMakeupsControllerTest < ActionController::TestCase
  setup do
    @food_makeup = food_makeups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:food_makeups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create food_makeup" do
    assert_difference('FoodMakeup.count') do
      post :create, :food_makeup => @food_makeup.attributes
    end

    assert_redirected_to food_makeup_path(assigns(:food_makeup))
  end

  test "should show food_makeup" do
    get :show, :id => @food_makeup.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @food_makeup.to_param
    assert_response :success
  end

  test "should update food_makeup" do
    put :update, :id => @food_makeup.to_param, :food_makeup => @food_makeup.attributes
    assert_redirected_to food_makeup_path(assigns(:food_makeup))
  end

  test "should destroy food_makeup" do
    assert_difference('FoodMakeup.count', -1) do
      delete :destroy, :id => @food_makeup.to_param
    end

    assert_redirected_to food_makeups_path
  end
end
