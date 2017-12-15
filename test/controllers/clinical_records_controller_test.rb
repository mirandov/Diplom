require 'test_helper'

class ClinicalRecordsControllerTest < ActionController::TestCase
  setup do
    @clinical_record = clinical_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clinical_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create clinical_record" do
    assert_difference('ClinicalRecord.count') do
      post :create, clinical_record: { attachment_date: @clinical_record.attachment_date, detachment_date: @clinical_record.detachment_date, last_registration_date: @clinical_record.last_registration_date, prefix: @clinical_record.prefix, reason_for_detachment: @clinical_record.reason_for_detachment, record_number: @clinical_record.record_number, site_id: @clinical_record.site_id, suffix: @clinical_record.suffix }
    end

    assert_redirected_to clinical_record_path(assigns(:clinical_record))
  end

  test "should show clinical_record" do
    get :show, id: @clinical_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @clinical_record
    assert_response :success
  end

  test "should update clinical_record" do
    patch :update, id: @clinical_record, clinical_record: { attachment_date: @clinical_record.attachment_date, detachment_date: @clinical_record.detachment_date, last_registration_date: @clinical_record.last_registration_date, prefix: @clinical_record.prefix, reason_for_detachment: @clinical_record.reason_for_detachment, record_number: @clinical_record.record_number, site_id: @clinical_record.site_id, suffix: @clinical_record.suffix }
    assert_redirected_to clinical_record_path(assigns(:clinical_record))
  end

  test "should destroy clinical_record" do
    assert_difference('ClinicalRecord.count', -1) do
      delete :destroy, id: @clinical_record
    end

    assert_redirected_to clinical_records_path
  end
end
