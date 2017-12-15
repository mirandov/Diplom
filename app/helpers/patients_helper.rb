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
end
