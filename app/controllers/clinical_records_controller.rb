class ClinicalRecordsController < ApplicationController
  before_action :set_clinical_record, only: [:show, :edit, :update, :destroy]

  # GET /clinical_records
  # GET /clinical_records.json
  def index
    @clinical_records = ClinicalRecord.all
  end

  # GET /clinical_records/1
  # GET /clinical_records/1.json
  def show
  end

  # GET /clinical_records/new
  def new
    @clinical_record = ClinicalRecord.new
  end

  # GET /clinical_records/1/edit
  def edit
  end

  # POST /clinical_records
  # POST /clinical_records.json
  def create
    @clinical_record = ClinicalRecord.new(clinical_record_params)

    respond_to do |format|
      if @clinical_record.save
        format.html { redirect_to @clinical_record, notice: 'Clinical record was successfully created.' }
        format.json { render :show, status: :created, location: @clinical_record }
      else
        format.html { render :new }
        format.json { render json: @clinical_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clinical_records/1
  # PATCH/PUT /clinical_records/1.json
  def update
    respond_to do |format|
      if @clinical_record.update(clinical_record_params)
        format.html { redirect_to @clinical_record, notice: 'Clinical record was successfully updated.' }
        format.json { render :show, status: :ok, location: @clinical_record }
      else
        format.html { render :edit }
        format.json { render json: @clinical_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clinical_records/1
  # DELETE /clinical_records/1.json
  def destroy
    @clinical_record.destroy
    respond_to do |format|
      format.html { redirect_to clinical_records_url, notice: 'Clinical record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clinical_record
      @clinical_record = ClinicalRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clinical_record_params
      params.require(:clinical_record).permit(:patient_id, :record_number, :prefix, :suffix, :attachment_date, :last_registration_date, :detachment_date, :reason_for_detachment, :site_id)
    end
end
