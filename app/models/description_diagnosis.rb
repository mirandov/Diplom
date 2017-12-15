class DescriptionDiagnosis < ActiveRecord::Base
  belongs_to :diagnosis
  belongs_to :complictation
end
