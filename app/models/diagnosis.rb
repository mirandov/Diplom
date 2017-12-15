class Diagnosis < ActiveRecord::Base
  belongs_to :patient
  belongs_to :position
end
