class MedicalPolicy < ActiveRecord::Base
  belongs_to :address

  has_one :patients

  accepts_nested_attributes_for :address
end
