module ReportsHelper
  def patients(companies)
    all = 0
    companies.each do |report|
      all += report[1][:all_patients].to_i
    end
    all
  end

  def start_period(patients)
    patients.each do |patient, report|
      q = patient[1][:start_period]
    end
    q
  end

end
