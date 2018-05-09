class PlaceWorkUseCase
  include UseCase

  attr_accessor :companies, :data
  attr_reader :begin_date, :end_date

  def initialize(companies, begin_date: nil, end_date: nil)
    @companies  = companies
    @data       = {}
    @begin_date = begin_date || "01.07.2016"
    @end_date   = end_date.presence

  end

  def perform
    all_patients = 0
    @companies.each do |company|
      under          = 0
      older          = 0
      under_male     = 0
      older_female   = 0
      under_female   = 0
      older_male     = 0
      patients_q      = []

      patients_all = Patient.where(place_work_id: company.id)
      patients_all.each do |patient|
        if (patient.clinical_record.last_registration_date > Date.parse(@begin_date)) || (patient.clinical_record.last_registration_date < Date.parse(@end_date))
          patients_q << patient
        end
      end
      
      years_15 = Date.today - 15.year

      patients_q.each do |old|
        all_patients += 1
        if old.birthday > years_15
          under +=1
          if old.sex == true
            under_male +=1
          else
            under_female +=1
          end
        else
          older +=1
          if old.sex == true
            older_male +=1
          else
            older_female +=1
          end
        end
      end

      @data[company] = {
        place_work:   company.job_name,
        all_patients: patients_q.size,
        under:        under,
        older:        older,
        under_male:   under_male,
        under_female: under_female,
        older_female: older_female,
        older_male:   older_male
      }
    end

    @data
  end

end
