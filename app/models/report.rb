class Report < ActiveRecord::Base
  has_one :upload, as: :attachable, dependent: :destroy
  enum report_type: { place_work_report: 1, movement_patients: 2, parent_patient: 3, site: 4, count_diseases: 5 }
end
