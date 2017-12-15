class ClinicalRecord < ActiveRecord::Base
  belongs_to :site

  has_one :patients


end
