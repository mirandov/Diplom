class Diagnosis < ActiveRecord::Base
  belongs_to :patient
  belongs_to :position
  belongs_to :doctor
  belongs_to :class_disease
  belongs_to :complictation
end
