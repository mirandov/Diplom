class Passport < ActiveRecord::Base
  has_one :patients
end
