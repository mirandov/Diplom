class ComplictationsController < ApplicationController
  before_action :set_complictation, only: [:show, :edit, :update, :destroy]

  # GET /complictations
  # GET /complictations.json
  def index
    @complictations = Complictation.all
  end

  # GET /complictations/1
  # GET /complictations/1.json
  def show
  end

  # GET /complictations/new
  def new
    @complictation = Complictation.new
  end

  # GET /complictations/1/edit
  def edit
  end

  # POST /complictations
  # POST /complictations.json
  def create
    @complictation = Complictation.new(complictation_params)

    respond_to do |format|
      if @complictation.save
        format.html { redirect_to @complictation, notice: 'Complictation was successfully created.' }
        format.json { render :show, status: :created, location: @complictation }
      else
        format.html { render :new }
        format.json { render json: @complictation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /complictations/1
  # PATCH/PUT /complictations/1.json
  def update
    respond_to do |format|
      if @complictation.update(complictation_params)
        format.html { redirect_to @complictation, notice: 'Complictation was successfully updated.' }
        format.json { render :show, status: :ok, location: @complictation }
      else
        format.html { render :edit }
        format.json { render json: @complictation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /complictations/1
  # DELETE /complictations/1.json
  def destroy
    @complictation.destroy
    respond_to do |format|
      format.html { redirect_to complictations_url, notice: 'Complictation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_complictation
      @complictation = Complictation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def complictation_params
      params.require(:complictation).permit(:name, :code, :information, :class_disease_id)
    end
end
