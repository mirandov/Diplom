class PlaceWorkUseCase
  include UseCase

  attr_accessor :companies, :data


  def initialize(companies, begin_date: nil, end_date: nil)
    @companies  = companies
    @data       = {}
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

      all = Patient.includes(:clinical_record).references(:clinical_record)
      patients   = all.where("clinical_records.detachment_date IS NULL AND
                            patients.place_work_id = ?",
                            company.id)

      years_15 = Date.today - 15.year

      patients.each do |old|
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
        all_patients: patients.size,
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
