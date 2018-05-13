class MovementPatientsUseCase
  include UseCase

  attr_accessor :companies, :data
  attr_reader :begin_date, :end_date

  def initialize(patients, begin_date: nil, end_date: nil, type: nil)
    @patients   = patients
    @type       = type
    @data       = {}
    @begin_date = begin_date || "01.07.2016"
    @end_date   = end_date.presence
  end

  def start_period
    patients = Patient.includes(:clinical_record).references(:clinical_record)
    period   = patients.where("clinical_records.attachment_date < ?  AND
                               clinical_records.detachment_date IS NULL",
                               @begin_date).size
  end

  def end_period
    patients = Patient.includes(:clinical_record).references(:clinical_record)
    period   = patients.where("clinical_records.attachment_date <= ?  AND
                               clinical_records.detachment_date IS NULL",
                               @end_date).size
  end

  def attach_to_period
    patients = Patient.includes(:clinical_record).references(:clinical_record)
    period   = patients.where("clinical_records.attachment_date >= ? AND
                               clinical_records.attachment_date <= ? ",
                               @begin_date, @end_date).size
  end

  def detach_to_period
    patients = Patient.includes(:clinical_record).references(:clinical_record)
    period   = patients.where("clinical_records.detachment_date >= ? AND
                               clinical_records.detachment_date <= ? ",
                               @begin_date, @end_date).size
  end


  def perform
    if @type == 'true'
      attachment_patients = attachment_patient
      id = 1

      attachment_patients.each do |patient|
        @data[patient] = {
          id:               id,
          place_work:       patient.place_work.job_name,
          clinical_record:  patient.clinical_record.record_number,
          site:             patient.clinical_record.site.site_name,
          full_name:        patient.surname + ' ' + patient.name + ' ' + patient.patronymic,
          birthday:         patient.birthday,
          attachment_date:  patient.clinical_record.attachment_date,
          start_period:     start_period,
          end_period:       end_period,
          attach_to_period: attach_to_period,
          detach_to_period: detach_to_period
        }
        id += 1
      end
    else
      detachment_patients = detachment_patient
      id = 1

      detachment_patients.each do |patient|
        @data[patient] = {
          id:               id,
          place_work:       patient.place_work.job_name,
          clinical_record:  patient.clinical_record.record_number,
          site:             patient.clinical_record.site.site_name,
          full_name:        patient.surname + ' ' + patient.name + ' ' + patient.patronymic,
          birthday:         patient.birthday,
          detachment_date:  patient.clinical_record.detachment_date,
          start_period:     start_period,
          end_period:       end_period,
          attach_to_period: attach_to_period,
          detach_to_period: detach_to_period
        }
        id += 1
      end
    end
    @data
  end

  def attachment_patient
    attachment_patients = []

    @patients.each do |patient|
      if (patient.clinical_record.last_registration_date > Date.parse(@begin_date)) && (patient.clinical_record.detachment_date == nil)
        attachment_patients << patient
      end
    end
    attachment_patients
  end

  def detachment_patient
    detachment_patients = []

    @patients.each do |patient|
      if (patient.clinical_record.last_registration_date > Date.parse(@begin_date)) && (patient.clinical_record.detachment_date != nil)
        detachment_patients << patient
      end
    end
    detachment_patients
  end

  end
