json.extract! clinical_record, :id, :record_number, :prefix, :suffix, :attachment_date, :last_registration_date, :detachment_date, :reason_for_detachment, :site_id, :created_at, :updated_at
json.url clinical_record_url(clinical_record, format: :json)
