module DiagnosesHelper
  def doctor_for_select
    Doctor.all.map {|d| [d.name, d.id]}
  end

  def patient_for_select
    Patient.all.map {|p| ["#{p.surname} #{p.name} #{p.patronymic}", p.id]}
  end

  def full_name(patient)
    result = patient.surname + " " + patient.name + " " + patient.patronymic
  end
end
