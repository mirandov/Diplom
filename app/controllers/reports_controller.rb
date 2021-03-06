class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :set_search_params, only: [:index]


  # GET /reports
  # GET /reports.json
  def index
    # @reports = Report.all.where(report_type: params[:type_report])
    @search = Report.search(params[:q])
    @reports = @search.result.page(params[:page])
  end

  def create
    @report.date_of_create = Date.today
    @report.save!
  end

  def all_reports

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
    unless params[:begin_date].nil?
      @report = Report.new
      @report.report_data = @children
      @report.name        = "Chislo zabolevaniy"
      @report.report_type = 5
      create
      create_reports
    end
  end

  def site
    children = params[:site].present? ? Patient.all : []
    usecase = SiteUseCase.new(children, site: params[:site])
    @children = usecase.perform
    unless params[:site].nil?
      @report = Report.new
      @report.report_data = @children
      @report.name        = "Uchastki"
      @report.report_type = 4
      create
      create_reports
    end
  end

  def parent_patient
    children = params[:place_work].present? ? Patient.all : []
    if params[:place_work].present?
      usecase = ParentPatientUseCase.new(children, place_work: params[:place_work])
      @children = usecase.perform

    else
      @children = []
    end
    unless params[:place_work].nil?
      @report = Report.new
      @report.report_data = @children
      @report.name        = "Kolichestvo detei po mestu sluzby roditelei"
      @report.report_type = 3
      create
      create_reports
    end
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
    unless params[:begin_date].nil?
      @report = Report.new
      @report.report_data = @patients
      @report.name        = "Dvizhenie patientov"
      @report.report_type = 2
      create
      create_reports
    end
  end

  def place_work_report
    @report = Report.new
    place_works = PlaceWork.all
    usecase     = PlaceWorkUseCase.new(place_works)
    @companies  = usecase.perform
    @report.report_data = @companies
    @report.name        = "Vozrasta patientov"
    @report.report_type = 1
    create
    create_reports
  end



  def create_reports
    @create_reports ||= Upload.new(upload_params)
    usecase = CreateReportsUseCase.new(@create_reports, @report)
    usecase.perform(reports_pdf_file)
  end


  private
  def set_search_params
    search_query = params[:q]&.clone
    @search = Patient.all.order('id ASC')
    @search = @search.ransack(search_query)
  end

  def reports_pdf_file
    kit = PDFKit.new(render_to_string(template: "reports/#{self.action_name}", layout: "#{self.action_name}"))
    kit.stylesheets << "/home/ldmirandov/Рабочий\ стол/diplom/Diplom/app/assets/stylesheets/print/report.css"
    kit.to_file "#{@report.name}#{Time.now}.pdf"
  end

  def upload_params
    params.fetch(:upload, {}).permit( :date_create_report,  extras: [:error, :error_event, :error_event_text])
  end

  def set_report
    @report = Report.find(params[:id])
  end
    # Never trust parameters from the scary internet, only allow the white list through.
  def report_params
    params.require(:report).permit(:report_data, :name, :report_type, :date_of_create)
  end
end
