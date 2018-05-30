class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all
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
      @report.save!
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
    unless params[:place_work].nil?
      usecase = ParentPatientUseCase.new(children, place_work: params[:place_work])
      @children = usecase.perform
      @report = Report.new
      @report.report_data = @children
      @report.name        = "Kolichestvo detei po mestu sluzby roditelei"
      @report.report_type = 3
      @report.save!
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
      @report.save!
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
    @report.save!
    create_reports
  end



  def create_reports
    @create_reports ||= Upload.new(upload_params)
    usecase = CreateReportsUseCase.new(@create_reports, @report)
    usecase.perform(complect_tests_reports_pdf_file)
  end


  private

  def complect_tests_reports_pdf_file
    kit = PDFKit.new(render_to_string(template: "reports/#{self.action_name}", layout: 'print'))
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
