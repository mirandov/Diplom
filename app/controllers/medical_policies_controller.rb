class MedicalPoliciesController < ApplicationController
  before_action :set_medical_policy, only: [:show, :edit, :update, :destroy]

  # GET /medical_policies
  # GET /medical_policies.json
  def index
    @medical_policies = MedicalPolicy.all
  end

  # GET /medical_policies/1
  # GET /medical_policies/1.json
  def show
  end

  # GET /medical_policies/new
  def new
    @medical_policy = MedicalPolicy.new
  end

  # GET /medical_policies/1/edit
  def edit
  end

  # POST /medical_policies
  # POST /medical_policies.json
  def create
    @medical_policy = MedicalPolicy.new(medical_policy_params)

    respond_to do |format|
      if @medical_policy.save
        format.html { redirect_to @medical_policy, notice: 'Medical policy was successfully created.' }
        format.json { render :show, status: :created, location: @medical_policy }
      else
        format.html { render :new }
        format.json { render json: @medical_policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /medical_policies/1
  # PATCH/PUT /medical_policies/1.json
  def update
    respond_to do |format|
      if @medical_policy.update(medical_policy_params)
        format.html { redirect_to @medical_policy, notice: 'Medical policy was successfully updated.' }
        format.json { render :show, status: :ok, location: @medical_policy }
      else
        format.html { render :edit }
        format.json { render json: @medical_policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /medical_policies/1
  # DELETE /medical_policies/1.json
  def destroy
    @medical_policy.destroy
    respond_to do |format|
      format.html { redirect_to medical_policies_url, notice: 'Medical policy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medical_policy
      @medical_policy = MedicalPolicy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def medical_policy_params
      params.require(:medical_policy).permit(:mip_number, :patient_id, :address_id)
    end
end
