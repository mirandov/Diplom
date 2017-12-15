require 'test_helper'

class ClassDiseasesControllerTest < ActionController::TestCase
  setup do
    @class_disease = class_diseases(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:class_diseases)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create class_disease" do
    assert_difference('ClassDisease.count') do
      post :create, class_disease: { code: @class_disease.code, information: @class_disease.information, name: @class_disease.name }
    end

    assert_redirected_to class_disease_path(assigns(:class_disease))
  end

  test "should show class_disease" do
    get :show, id: @class_disease
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @class_disease
    assert_response :success
  end

  test "should update class_disease" do
    patch :update, id: @class_disease, class_disease: { code: @class_disease.code, information: @class_disease.information, name: @class_disease.name }
    assert_redirected_to class_disease_path(assigns(:class_disease))
  end

  test "should destroy class_disease" do
    assert_difference('ClassDisease.count', -1) do
      delete :destroy, id: @class_disease
    end

    assert_redirected_to class_diseases_path
  end
end
