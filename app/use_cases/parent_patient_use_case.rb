class ParentPatientUseCase
  include UseCase

  attr_accessor :companies, :data
  attr_reader :place_work

  def initialize(children, place_work: nil)
    @place_work = place_work
    @children   = children
    @data       = {}
  end

  def ages(patients,begin_date, end_date)
    today = Date.today
    under = today - begin_date.year
    older = today - end_date.year
    girls = 0
    boys  = 0
    children = []

    patients.each do |patient|
      if patient.birthday > under && patient.birthday < older
        if patient.sex == true
          boys += 1
        else
          girls += 1
        end
      end
    end

    children << boys
    children << girls

    children
  end


  def perform
    all_patients = 0

    all = Patient.includes(:clinical_record).references(:clinical_record)
    patients   = all.where("clinical_records.detachment_date IS NULL AND
                          patients.place_work_id = ?",
                          @place_work)
    @children = patients
    
    under_1_year  = ages(@children,1,0)
    under_3_year  = ages(@children,3,1)
    under_6_year  = ages(@children,6,3)
    under_15_year = ages(@children,15,6)
    under_17_year = ages(@children,17,15)
    under_18_year = ages(@children,18,17)
    older_18_year = ages(@children,99,18)

    @data[@children] = {
      girls_u1:   under_1_year.last,
      girls_u3:   under_3_year.last,
      girls_u6:   under_6_year.last,
      girls_u15:  under_15_year.last,
      girls_u17:  under_17_year.last,
      girls_u18:  under_18_year.last,
      girls_o18:  older_18_year.last,
      boys_u1:    under_1_year.first,
      boys_u3:    under_3_year.first,
      boys_u6:    under_6_year.first,
      boys_u15:   under_15_year.first,
      boys_u17:   under_17_year.first,
      boys_u18:   under_18_year.first,
      boys_o18:   older_18_year.first
    }
    @data
  end

end
