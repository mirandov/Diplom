class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]

  # GET /reports
  # GET /reports.json
  def index

  end

  def movement_patients
    patients  = params[:begin_date].present? && params[:end_date].present? ? Patient.all : []
    if params[:type] == 'Открепленные'
      params[:type] = 'false'
    else
      params[:type] = 'true'
    end
    usecase   = MovementPatientsUseCase.new(patients, begin_date: params[:begin_date], end_date: params[:end_date], type: params[:type])
    @patients = usecase.perform
  end

  def place_work_report
    place_works = params[:begin_date].present? && params[:end_date].present? ? PlaceWork.all : []
    usecase     = PlaceWorkUseCase.new(place_works, begin_date: params[:begin_date], end_date: params[:end_date])
    @companies  = usecase.perform
  end

end
