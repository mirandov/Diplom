class CreateReportsUseCase
  include UseCase
  attr_accessor :report, :complect_tests_report, :party, :person
  def initialize(report, complect_tests_report)
      @report = report
      @complect_tests_report = complect_tests_report

    end

    def perform(file)
      Upload.transaction do
        attach_pdf(file)
        true
      end
    end

    private

    def attach_pdf(file)
      report.assign_attributes(attachable: complect_tests_report,attachment: file)
      complect_tests_report.upload = report
      complect_tests_report.upload.save!
    end
  end
