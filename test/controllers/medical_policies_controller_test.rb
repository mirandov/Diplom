require 'test_helper'

class MedicalPoliciesControllerTest < ActionController::TestCase
  setup do
    @medical_policy = medical_policies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:medical_policies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create medical_policy" do
    assert_difference('MedicalPolicy.count') do
      post :create, medical_policy: { address_id: @medical_policy.address_id, mip_number: @medical_policy.mip_number }
    end

    assert_redirected_to medical_policy_path(assigns(:medical_policy))
  end

  test "should show medical_policy" do
    get :show, id: @medical_policy
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @medical_policy
    assert_response :success
  end

  test "should update medical_policy" do
    patch :update, id: @medical_policy, medical_policy: { address_id: @medical_policy.address_id, mip_number: @medical_policy.mip_number }
    assert_redirected_to medical_policy_path(assigns(:medical_policy))
  end

  test "should destroy medical_policy" do
    assert_difference('MedicalPolicy.count', -1) do
      delete :destroy, id: @medical_policy
    end

    assert_redirected_to medical_policies_path
  end
end
