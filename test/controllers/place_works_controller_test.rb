require 'test_helper'

class PlaceWorksControllerTest < ActionController::TestCase
  setup do
    @place_work = place_works(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:place_works)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create place_work" do
    assert_difference('PlaceWork.count') do
      post :create, place_work: { information: @place_work.information, job_name: @place_work.job_name, short_name: @place_work.short_name }
    end

    assert_redirected_to place_work_path(assigns(:place_work))
  end

  test "should show place_work" do
    get :show, id: @place_work
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @place_work
    assert_response :success
  end

  test "should update place_work" do
    patch :update, id: @place_work, place_work: { information: @place_work.information, job_name: @place_work.job_name, short_name: @place_work.short_name }
    assert_redirected_to place_work_path(assigns(:place_work))
  end

  test "should destroy place_work" do
    assert_difference('PlaceWork.count', -1) do
      delete :destroy, id: @place_work
    end

    assert_redirected_to place_works_path
  end
end
