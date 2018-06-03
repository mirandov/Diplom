module ReportsHelper

  def age_down_select
    result = [1,15]
  end

  def age_up_select
    result = [14,18]
  end

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

  def place_work_for_select
    result = PlaceWork.all.map {|p| [p.job_name, p.id]}
  end

  def site_for_select
    result = Site.all.map {|s| [s.site_name, s.id]}
  end

  def report_for_select
    Report.all.map{|r| [r.report_type, r.id]}
  end
end
