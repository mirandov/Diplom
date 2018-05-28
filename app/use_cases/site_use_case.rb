class SiteUseCase
  include UseCase
  attr_accessor :site, :data

  def initialize(children, site: nil)
    @site     = site
    @children = children
    @data     = {}
  end

  def perform
    all = Patient.includes(:clinical_record).references(:clinical_record)
    patients   = all.where("clinical_records.detachment_date IS NULL AND
                            clinical_records.site_id = ?",
                            @site)
    @children = patients
    @children.each do |child|
      @data[child.id]= {
       name:    child.surname + " " +  child.name + " " + child.patronymic,
       birthday: child.birthday,
       adress:   child.address_reg
      }
    end
    @data
  end
end
