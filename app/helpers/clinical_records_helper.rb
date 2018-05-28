module ClinicalRecordsHelper
  def full_record_number(clinical_record)
    clinical_record.record_number.present? ? "#{clinical_record.prefix}-#{clinical_record.record_number}/#{clinical_record.suffix}" : "Данные отсутствуют"
  end

  def full_name(clinical_record)
    clinical_record.patient.present?  ?  "#{clinical_record.patient.surname} #{clinical_record.patient.name} #{clinical_record.patient.patronymic}" : "Данные отсутствуют"
  end

  def linked_list(clinical_record)
    content_tag(:ul, link_to(full_name(clinical_record), patient_path(clinical_record.patient)))
  end
end
