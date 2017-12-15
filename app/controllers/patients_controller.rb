class PatientsController < ApplicationController
  before_action :set_patient, only: [:show, :edit, :update, :destroy]

  # GET /patients
  # GET /patients.json
  def index
    @patients = Patient.all
  end

  # GET /patients/1
  # GET /patients/1.json
  def show
  end

  # GET /patients/new
  def new
    @patient          = Patient.new
    @passport         = @patient.build_passport
    @medical_policy   = @patient.build_medical_policy
    @clinical_record  = @patient.build_clinical_record
    @address          = @patient.build_address
  end

  # GET /patients/1/edit
  def edit
  end

  # POST /patients
  # POST /patients.json
  def create
    @patient = Patient.new(patient_params)

    respond_to do |format|
      if @patient.save
        format.html { redirect_to @patient, notice: 'Patient was successfully created.' }
        format.json { render :show, status: :created, location: @patient }
      else
        format.html { render :new }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /patients/1
  # PATCH/PUT /patients/1.json
  def update
    respond_to do |format|
      if @patient.update(patient_params)
        format.html { redirect_to @patient, notice: 'Patient was successfully updated.' }
        format.json { render :show, status: :ok, location: @patient }
      else
        format.html { render :edit }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.json
  def destroy
    @patient.destroy
    respond_to do |format|
      format.html { redirect_to patients_url, notice: 'Patient was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patient
      @patient = Patient.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def patient_params
      params.require(:patient).permit(
        :surname,
        :name,
        :patronymic,
        :birthday,
        :sex,
        :full_name_parent,
        :mobile_phone_number,
        :work_phone_number,
        :rank,
        :disability,
        :certificate_of_deceased_parent,
        :certificate_of_nuclear_power_plant,
        :inila,
        :place_work_id,
        :address_id,
        :clinical_record_id,
        :medical_policy_id,
        :passport_attributes => [
          :id,
          :serial_and_number,
          :issue_date,
          :issued_by,
          :passport_holder
        ],
        :medical_policy_attributes => [
          :id,
          :mip_number,
          :address_id
        ],
        :clinical_record_attributes => [
          :id,
          :record_number,
          :prefix,
          :suffix,
          :attachment_date,
          :last_registration_date,
          :detachment_date,
          :reason_for_detachment,
          :site_id
        ],
        :address_attributes => [
          :id,
          :site_id,
          :city_id,
          :street_id,
          :house_id
        ]
      )
    end
end
