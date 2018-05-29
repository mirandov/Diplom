class Upload < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true
  has_attached_file :attachment
  do_not_validate_attachment_file_type :attachment

  store_accessor :extras, :conclusion, :conclusion_doctor, :therapy, :doctor_id, :therapy_type, :therapy_block, :high_pressure_block, :error_event, :error_event_text

  def datetime_to_name
    "#{created_at.strftime('%Y%m%d %H:%M')}"
  end

end
