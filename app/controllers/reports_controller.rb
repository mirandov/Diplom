class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]

  # GET /reports
  # GET /reports.json
  def index
  end

  def count_diseases
    children = params[:begin_date].present? && params[:end_date].present? ? Patient.all : []
    if params[:begin_date].present?
      usecase = DiseasesUseCase.new(children, begin_date: params[:begin_date],
                                    end_date: params[:end_date], age_up: params[:age_up],
                                    age_down: params[:age_down])
      @children = usecase.perform
    else
      @children = []
    end
  end
  def site
    children = params[:site].present? ? Patient.all : []
    usecase = SiteUseCase.new(children, site: params[:site])
    @children = usecase.perform
  end
  def parent_patient
    children = params[:place_work].present? ? Patient.all : []
    usecase = ParentPatientUseCase.new(children, place_work: params[:place_work])
    @children = usecase.perform
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
    place_works = PlaceWork.all
    usecase     = PlaceWorkUseCase.new(place_works)
    @companies  = usecase.perform
  end

end
