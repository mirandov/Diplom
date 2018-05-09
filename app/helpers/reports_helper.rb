module ReportsHelper
  def patients(companies)
    all = 0
    
    companies.each do |report|
      all += report[1][:all_patients].to_i
    end
    all
  end
end
