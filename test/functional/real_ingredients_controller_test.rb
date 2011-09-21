require 'test_helper'

class RealIngredientsControllerTest < ActionController::TestCase
  setup do
    @real_ingredient = real_ingredients(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:real_ingredients)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create real_ingredient" do
    assert_difference('RealIngredient.count') do
      post :create, :real_ingredient => @real_ingredient.attributes
    end

    assert_redirected_to real_ingredient_path(assigns(:real_ingredient))
  end

  test "should show real_ingredient" do
    get :show, :id => @real_ingredient.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @real_ingredient.to_param
    assert_response :success
  end

  test "should update real_ingredient" do
    put :update, :id => @real_ingredient.to_param, :real_ingredient => @real_ingredient.attributes
    assert_redirected_to real_ingredient_path(assigns(:real_ingredient))
  end

  test "should destroy real_ingredient" do
    assert_difference('RealIngredient.count', -1) do
      delete :destroy, :id => @real_ingredient.to_param
    end

    assert_redirected_to real_ingredients_path
  end
end
