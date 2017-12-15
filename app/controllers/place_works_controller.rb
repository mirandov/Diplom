class PlaceWorksController < ApplicationController
  before_action :set_place_work, only: [:show, :edit, :update, :destroy]

  # GET /place_works
  # GET /place_works.json
  def index
    @place_works = PlaceWork.all
  end

  # GET /place_works/1
  # GET /place_works/1.json
  def show
  end

  # GET /place_works/new
  def new
    @place_work = PlaceWork.new
  end

  # GET /place_works/1/edit
  def edit
  end

  # POST /place_works
  # POST /place_works.json
  def create
    @place_work = PlaceWork.new(place_work_params)

    respond_to do |format|
      if @place_work.save
        format.html { redirect_to @place_work, notice: 'Place work was successfully created.' }
        format.json { render :show, status: :created, location: @place_work }
      else
        format.html { render :new }
        format.json { render json: @place_work.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /place_works/1
  # PATCH/PUT /place_works/1.json
  def update
    respond_to do |format|
      if @place_work.update(place_work_params)
        format.html { redirect_to @place_work, notice: 'Place work was successfully updated.' }
        format.json { render :show, status: :ok, location: @place_work }
      else
        format.html { render :edit }
        format.json { render json: @place_work.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /place_works/1
  # DELETE /place_works/1.json
  def destroy
    @place_work.destroy
    respond_to do |format|
      format.html { redirect_to place_works_url, notice: 'Place work was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place_work
      @place_work = PlaceWork.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def place_work_params
      params.require(:place_work).permit(:job_name, :short_name, :information)
    end
end
