class CreateReportsUseCase
  include UseCase
  attr_accessor :report, :complect_tests_report, :party, :person
  def initialize(report_file, report)
    @report_file = report_file
    @report = complect_tests_report
    @party = party
    @person = person
  end

  def perform(file)
    Upload.transaction do
      # attach_pdf(file)
      true
    end
  end

  private

  def attach_pdf(file)
    report_file.assign_attributes(attachable: report, attachment: file)
    report.upload = report_file
    report.upload.save!
  end
end
