require 'test_helper'

class PatientsControllerTest < ActionController::TestCase
  setup do
    @patient = patients(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:patients)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create patient" do
    assert_difference('Patient.count') do
      post :create, patient: { address_id: @patient.address_id, birthday: @patient.birthday, certificate_of_deceased_parent: @patient.certificate_of_deceased_parent, certificate_of_nuclear_power_plant: @patient.certificate_of_nuclear_power_plant, clinical_record_id: @patient.clinical_record_id, disability: @patient.disability, full_name_parent: @patient.full_name_parent, inila: @patient.inila, medical_policy_id: @patient.medical_policy_id, mobile_phone_number: @patient.mobile_phone_number, name: @patient.name, passport_id: @patient.passport_id, patronymic: @patient.patronymic, place_work_id: @patient.place_work_id, rank: @patient.rank, sex: @patient.sex, surname: @patient.surname, work_phone_number: @patient.work_phone_number }
    end

    assert_redirected_to patient_path(assigns(:patient))
  end

  test "should show patient" do
    get :show, id: @patient
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @patient
    assert_response :success
  end

  test "should update patient" do
    patch :update, id: @patient, patient: { address_id: @patient.address_id, birthday: @patient.birthday, certificate_of_deceased_parent: @patient.certificate_of_deceased_parent, certificate_of_nuclear_power_plant: @patient.certificate_of_nuclear_power_plant, clinical_record_id: @patient.clinical_record_id, disability: @patient.disability, full_name_parent: @patient.full_name_parent, inila: @patient.inila, medical_policy_id: @patient.medical_policy_id, mobile_phone_number: @patient.mobile_phone_number, name: @patient.name, passport_id: @patient.passport_id, patronymic: @patient.patronymic, place_work_id: @patient.place_work_id, rank: @patient.rank, sex: @patient.sex, surname: @patient.surname, work_phone_number: @patient.work_phone_number }
    assert_redirected_to patient_path(assigns(:patient))
  end

  test "should destroy patient" do
    assert_difference('Patient.count', -1) do
      delete :destroy, id: @patient
    end

    assert_redirected_to patients_path
  end
end
