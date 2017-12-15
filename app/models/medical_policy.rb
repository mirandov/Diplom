class MedicalPolicy < ActiveRecord::Base
  belongs_to :address
  
  has_one :patients
end
