class DescriptionDiagnosesController < ApplicationController
  before_action :set_description_diagnosis, only: [:show, :edit, :update, :destroy]

  # GET /description_diagnoses
  # GET /description_diagnoses.json
  def index
    @description_diagnoses = DescriptionDiagnosis.all
  end

  # GET /description_diagnoses/1
  # GET /description_diagnoses/1.json
  def show
  end

  # GET /description_diagnoses/new
  def new
    @description_diagnosis = DescriptionDiagnosis.new
  end

  # GET /description_diagnoses/1/edit
  def edit
  end

  # POST /description_diagnoses
  # POST /description_diagnoses.json
  def create
    @description_diagnosis = DescriptionDiagnosis.new(description_diagnosis_params)

    respond_to do |format|
      if @description_diagnosis.save
        format.html { redirect_to @description_diagnosis, notice: 'Description diagnosis was successfully created.' }
        format.json { render :show, status: :created, location: @description_diagnosis }
      else
        format.html { render :new }
        format.json { render json: @description_diagnosis.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /description_diagnoses/1
  # PATCH/PUT /description_diagnoses/1.json
  def update
    respond_to do |format|
      if @description_diagnosis.update(description_diagnosis_params)
        format.html { redirect_to @description_diagnosis, notice: 'Description diagnosis was successfully updated.' }
        format.json { render :show, status: :ok, location: @description_diagnosis }
      else
        format.html { render :edit }
        format.json { render json: @description_diagnosis.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /description_diagnoses/1
  # DELETE /description_diagnoses/1.json
  def destroy
    @description_diagnosis.destroy
    respond_to do |format|
      format.html { redirect_to description_diagnoses_url, notice: 'Description diagnosis was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_description_diagnosis
      @description_diagnosis = DescriptionDiagnosis.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def description_diagnosis_params
      params.require(:description_diagnosis).permit(:comment, :diagnosis_id, :complictation_id)
    end
end
