json.extract! patient, :id, :surname, :name, :patronymic, :birthday, :sex, :full_name_parent, :mobile_phone_number, :work_phone_number, :rank, :disability, :certificate_of_deceased_parent, :certificate_of_nuclear_power_plant, :inila, :place_work_id, :address_id, :clinical_record_id, :medical_policy_id, :passport_id, :created_at, :updated_at
json.url patient_url(patient, format: :json)
