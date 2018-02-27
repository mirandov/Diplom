class MedicalPolicy < ActiveRecord::Base
  belongs_to :address

  belongs_to :patient

  accepts_nested_attributes_for :address
end
