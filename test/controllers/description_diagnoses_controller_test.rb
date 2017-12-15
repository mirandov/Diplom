require 'test_helper'

class DescriptionDiagnosesControllerTest < ActionController::TestCase
  setup do
    @description_diagnosis = description_diagnoses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:description_diagnoses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create description_diagnosis" do
    assert_difference('DescriptionDiagnosis.count') do
      post :create, description_diagnosis: { comment: @description_diagnosis.comment, complictation_id: @description_diagnosis.complictation_id, diagnosis_id: @description_diagnosis.diagnosis_id }
    end

    assert_redirected_to description_diagnosis_path(assigns(:description_diagnosis))
  end

  test "should show description_diagnosis" do
    get :show, id: @description_diagnosis
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @description_diagnosis
    assert_response :success
  end

  test "should update description_diagnosis" do
    patch :update, id: @description_diagnosis, description_diagnosis: { comment: @description_diagnosis.comment, complictation_id: @description_diagnosis.complictation_id, diagnosis_id: @description_diagnosis.diagnosis_id }
    assert_redirected_to description_diagnosis_path(assigns(:description_diagnosis))
  end

  test "should destroy description_diagnosis" do
    assert_difference('DescriptionDiagnosis.count', -1) do
      delete :destroy, id: @description_diagnosis
    end

    assert_redirected_to description_diagnoses_path
  end
end
