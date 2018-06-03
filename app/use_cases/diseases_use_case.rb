class DiseasesUseCase
  include UseCase

  def initialize(children, begin_date: nil, end_date: nil, age_up: nil, age_down: nil)
    @age_up   = age_up
    @age_down = age_down

    @children = children
    @q        = {}
    @data     = {}
    @begin_date = begin_date || "01.07.2016"
    @end_date   = end_date.presence
  end

  def perform
    size = ClassDisease.all.size
    all_patient = Diagnosis.all.where("(diagnoses.resolution_date > ? AND
                                      diagnoses.resolution_date < ?)",
                                      @begin_date, @end_date).group("diagnoses.class_disease_id").size

    male = Patient.includes(:diagnoses).references(:diagnoses)
    male = male.all.where("(diagnoses.resolution_date > ? AND
                                      diagnoses.resolution_date < ? AND patients.sex = true)",
                                      @begin_date, @end_date).group("diagnoses.class_disease_id").size

    first_in_live = Diagnosis.all.where("(diagnoses.resolution_date > ? AND
                                      diagnoses.resolution_date < ? AND diagnoses.first_in_live = true)",
                                      @begin_date, @end_date).group("diagnoses.class_disease_id").size

    first_in_live_male = Patient.includes(:diagnoses).references(:diagnoses)
    first_in_live_male = first_in_live_male.all.where("(diagnoses.resolution_date > ? AND
                                      diagnoses.resolution_date < ? AND
                                      patients.sex = true AND
                                      diagnoses.first_in_live = true)",
                                      @begin_date, @end_date).group("diagnoses.class_disease_id").size

    prof = Diagnosis.all.where("(diagnoses.resolution_date > ? AND
                                      diagnoses.resolution_date < ? AND diagnoses.prof = true)",
                                      @begin_date, @end_date).group("diagnoses.class_disease_id").size

    prof_male = Patient.includes(:diagnoses).references(:diagnoses)
    prof_male = prof_male.all.where("(diagnoses.resolution_date > ? AND
                                      diagnoses.resolution_date < ? AND
                                      patients.sex = true AND
                                      diagnoses.prof = true)",
                                      @begin_date, @end_date).group("diagnoses.class_disease_id").size



    for i in 1..size

      if first_in_live[i] == nil
        first_in_live[i] = 0
      end

      if first_in_live_male[i] == nil
        first_in_live_male[i] = 0
      end

      if prof[i] == nil
        prof[i] = 0
      end

      if prof_male[i] == nil
        prof_male[i] = 0
      end

      if all_patient[i] == nil
        all_patient[i] = 0
      end

      if male[i] == nil
        male[i] = 0
      end

      @data["#{ClassDisease.where(id: i)[0].name}"] ={
         code:         ClassDisease.where(id: i)[0].code,
         count:        all_patient[i],
         count_male:   male[i],
         count_fil:    first_in_live[i],
         count_fil_m:  first_in_live_male[i],
         count_prof:   prof[i],
         count_prof_m: prof_male[i]
       }
    end
    @q["period"] = {
      begin_date: @begin_date,
      end_date:   @end_date
    }
    @data = @data.merge(@q)
  end

end
