require 'test_helper'

class OverviewsControllerTest < ActionController::TestCase
  setup do
    @overview = overviews(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:overviews)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create overview" do
    assert_difference('Overview.count') do
      post :create, overview: {  }
    end

    assert_redirected_to overview_path(assigns(:overview))
  end

  test "should show overview" do
    get :show, id: @overview
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @overview
    assert_response :success
  end

  test "should update overview" do
    patch :update, id: @overview, overview: {  }
    assert_redirected_to overview_path(assigns(:overview))
  end

  test "should destroy overview" do
    assert_difference('Overview.count', -1) do
      delete :destroy, id: @overview
    end

    assert_redirected_to overviews_path
  end
end
