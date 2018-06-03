class CreateReportsUseCase
  include UseCase
  attr_accessor :report, :data_report, :party, :person
  def initialize(report, data_report)
      @report = report
      @data_report = data_report

    end

    def perform(file)
      Upload.transaction do
        attach_pdf(file)
        true
      end
    end

    private

    def attach_pdf(file)
      report.assign_attributes(attachable: data_report,attachment: file)
      data_report.upload = report
      data_report.upload.save!
    end
  end
