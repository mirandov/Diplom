require 'test_helper'

class ComplictationsControllerTest < ActionController::TestCase
  setup do
    @complictation = complictations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:complictations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create complictation" do
    assert_difference('Complictation.count') do
      post :create, complictation: { class_disease_id: @complictation.class_disease_id, code: @complictation.code, information: @complictation.information, name: @complictation.name }
    end

    assert_redirected_to complictation_path(assigns(:complictation))
  end

  test "should show complictation" do
    get :show, id: @complictation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @complictation
    assert_response :success
  end

  test "should update complictation" do
    patch :update, id: @complictation, complictation: { class_disease_id: @complictation.class_disease_id, code: @complictation.code, information: @complictation.information, name: @complictation.name }
    assert_redirected_to complictation_path(assigns(:complictation))
  end

  test "should destroy complictation" do
    assert_difference('Complictation.count', -1) do
      delete :destroy, id: @complictation
    end

    assert_redirected_to complictations_path
  end
end
