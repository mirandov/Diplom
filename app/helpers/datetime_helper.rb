module DatetimeHelper
  def time_pattern
    '([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]'
  end

  def to_datepicker_format(date_or_time)
    date_or_time.to_datetime.strftime('%d.%m.%Y')
  end

  # Generate awesome datepicker field
  def datepicker_field(form, field_name, params = {})
    label = params[:label]
    icon  = params[:icon]
    if params.delete(:show_time)
      class_name = 'datetimepicker'
      format     = :default
    else
      class_name = 'datepicker'
      format     = :default
    end
    options = { as: :string, class: class_name }.merge(params)
    value = form.object.try(field_name)
    options[:value] ||= localize(value, format: format) if value

    input_opts = { wrapper: :append }
    input_opts[:label] = label

    form.input(field_name, input_opts) do
      form.input_field(field_name, options) + \
      content_tag(:span, class: 'input-group-addon') do
        content_tag(:span, nil, class: 'glyphicon glyphicon-calendar') if icon
      end
    end
  end

  # Convert Time, Date or DateTime object to number
  # of microseconds since 1970-01-01 00:00:00 UTC
  def to_microseconds(date_or_time)
    date_or_time.to_datetime.strftime('%Q')
  end

  def ftime(date)
    date&.strftime("%d.%m.%y в %H:%M:%S")
  end

end
