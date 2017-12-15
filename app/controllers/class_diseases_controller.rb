class ClassDiseasesController < ApplicationController
  before_action :set_class_disease, only: [:show, :edit, :update, :destroy]

  # GET /class_diseases
  # GET /class_diseases.json
  def index
    @class_diseases = ClassDisease.all
  end

  # GET /class_diseases/1
  # GET /class_diseases/1.json
  def show
  end

  # GET /class_diseases/new
  def new
    @class_disease = ClassDisease.new
  end

  # GET /class_diseases/1/edit
  def edit
  end

  # POST /class_diseases
  # POST /class_diseases.json
  def create
    @class_disease = ClassDisease.new(class_disease_params)

    respond_to do |format|
      if @class_disease.save
        format.html { redirect_to @class_disease, notice: 'Class disease was successfully created.' }
        format.json { render :show, status: :created, location: @class_disease }
      else
        format.html { render :new }
        format.json { render json: @class_disease.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /class_diseases/1
  # PATCH/PUT /class_diseases/1.json
  def update
    respond_to do |format|
      if @class_disease.update(class_disease_params)
        format.html { redirect_to @class_disease, notice: 'Class disease was successfully updated.' }
        format.json { render :show, status: :ok, location: @class_disease }
      else
        format.html { render :edit }
        format.json { render json: @class_disease.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /class_diseases/1
  # DELETE /class_diseases/1.json
  def destroy
    @class_disease.destroy
    respond_to do |format|
      format.html { redirect_to class_diseases_url, notice: 'Class disease was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_class_disease
      @class_disease = ClassDisease.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def class_disease_params
      params.require(:class_disease).permit(:name, :code, :information)
    end
end
