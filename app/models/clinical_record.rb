class ClinicalRecord < ActiveRecord::Base
  belongs_to :site

  belongs_to :patient


end
