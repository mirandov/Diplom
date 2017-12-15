class Address < ActiveRecord::Base
  belongs_to :site
  belongs_to :city
  belongs_to :street
  belongs_to :house
  
  has_many :patients
  has_many :medical_policies
end
