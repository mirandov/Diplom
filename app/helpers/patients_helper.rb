module PatientsHelper

  def place_work_for_select
    result = PlaceWork.all.map {|p| [p.job_name, p.id]}
  end

  def site_for_select
    result = Site.all.map {|s| [s.site_name, s.id]}
  end

  def city_for_select
    result = City.all.map {|c| [c.city_name, c.id]}
  end

  def street_for_select
    result = Street.all.map {|s| [s.street_name, s.id]}
  end

  def house_for_select
    result = House.all.map {|h| [h.house_number, h.id]}
  end

  def full_record_number(clinical_record)
  clinical_record.record_number.present? ? "#{clinical_record.prefix}-#{clinical_record.record_number}/#{clinical_record.suffix}" : "Данные отсутствуют"
  end

  def full_address(address)
    address.city.nil? ? "Адрес не указан" : "#{address.city.city_name}, ул. #{address.street.street_name}, д. #{address.house.house_number}"
  end

  def full_mip_number(medical_policy)
    medical_policy.mip_number.present? ? medical_policy.mip_number : "Данные отсутствуют"
  end
end
