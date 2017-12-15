json.extract! diagnosis, :id, :resolution_date, :patient_id, :position_id, :created_at, :updated_at
json.url diagnosis_url(diagnosis, format: :json)
