require 'test_helper'

class OpinionsControllerTest < ActionController::TestCase
  setup do
    @opinion = opinions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:opinions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create opinion" do
    assert_difference('Opinion.count') do
      post :create, opinion: { like: @opinion.like, restaurant_id: @opinion.restaurant_id, user_id: @opinion.user_id }
    end

    assert_redirected_to opinion_path(assigns(:opinion))
  end

  test "should show opinion" do
    get :show, id: @opinion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @opinion
    assert_response :success
  end

  test "should update opinion" do
    patch :update, id: @opinion, opinion: { like: @opinion.like, restaurant_id: @opinion.restaurant_id, user_id: @opinion.user_id }
    assert_redirected_to opinion_path(assigns(:opinion))
  end

  test "should destroy opinion" do
    assert_difference('Opinion.count', -1) do
      delete :destroy, id: @opinion
    end

    assert_redirected_to opinions_path
  end
end
