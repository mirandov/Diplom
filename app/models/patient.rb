class Patient < ActiveRecord::Base
  belongs_to :place_work
  belongs_to :address

  has_one :clinical_record, dependent: :destroy
  has_one :medical_policy, dependent: :destroy
  has_one :passport, dependent: :destroy

  has_many :diagnoses

  accepts_nested_attributes_for :passport
  accepts_nested_attributes_for :medical_policy
  accepts_nested_attributes_for :clinical_record
end
