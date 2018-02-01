# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $complect_form = $('form[id^="edit_med_program_"]:first')
  number_of_days = parseInt($('#med_program_template_duration', $complect_form).val()) - 1 # Первый день включительно.
  $end_date_field = $('#med_program_end_date', $complect_form)

  $complect_type_radio = $('#complect_type_radio', $complect_form).on 'click', 'input[name="complect_type_id[]"]', ()->
    if $end_date_field.val()
      id = location.pathname.split('/', 4)[2]
      $('#complect_type_rows', $complect_form).load("/med_programs/#{id}/complects/#{$(this).val()}?begin_data=#{begin_date_field.val()}")
    return
  $('input[name="complect_type_id[]"]:checked', $complect_type_radio).click()

  begin_date_field = $('#med_program_begin_date', $complect_form).change ()->
    day_in_ms = 86400000
    date = new Date($(this).val().replace(/(\d{2})\.(\d{2})\.(\d{4})/, '$3-$2-$1'))
    radios = $('input[name="complect_type_id[]"]', $complect_type_radio)
    if time = date.getTime()
      date.setTime(time + number_of_days * day_in_ms)
      formatted_data = "#{('0' + date.getDate()).slice(-2)}.#{('0' + (date.getMonth() + 1)).slice(-2)}.#{date.getFullYear()}"
      radios.prop('disabled', false).filter(':checked').click()
    else
      formatted_data = ''
      radios.prop('disabled', true)
      $('#complect_type_rows', $complect_form).html('')

    $end_date_field.val(formatted_data)
    return
  .change()

  $complect_form.on 'click', 'button[type="submit"]', ->
    $('#med_program_complect_id', $complect_form).val($(this).data('complect-id'))
    return

  form = $('form[id^="add_doctor_to_med_program_"]:first')

  $('#submit_btn', form).removeClass('hide')

  $a_doctor_fld = $('#med_program_doctor_id', form)

  # See more: http://loopj.com/jquery-tokeninput/#configuration
  tokenInputOptions = {
    crossDomain: false,
    hintText: "Введите фамилию, имя или отчество"
    noResultText: "Ничего не найдено"
    searchingText: "Поиск"
    preventDuplicates: true
    propertyToSearch: 'full_name'
    minChars: 3
    tokenLimit: 1
  }

  $a_doctor_fld.tokenInput($a_doctor_fld.data('token-input-url'), $.extend({}, tokenInputOptions, {prePopulate: $a_doctor_fld.data('pre')}))
  .change ()->
    $this = $(this)
    cond = parseInt($this.val()) > 0
    $('#add_new_doctor_btn, #no_doctor_btn', form).toggle !cond
    $('#submit_btn', form).toggle cond
    return
  .change()


  $a_person_fld = $('#med_program_person')

  # See more: http://loopj.com/jquery-tokeninput/#configuration
  tokenInputOptions = {
    crossDomain: false,
    hintText: "Введите фамилию, имя или отчество"
    noResultText: "Ничего не найдено"
    searchingText: "Поиск"
    preventDuplicates: true
    propertyToSearch: 'full_name'
    minChars: 3
    tokenLimit: 1
  }

  $a_person_fld.tokenInput($a_person_fld.data('token-input-url'), $.extend({}, tokenInputOptions, {prePopulate: $a_person_fld.data('pre')}))
  .change ()->
    $this = $(this)
    person_param = { person_id: $this.val() }
    url = ""
    if $this.data('query-url').indexOf("?") != -1
      url = $this.data('query-url') + "&" + $.param(person_param)
    else
      url = $this.data('query-url') + "?" + $.param(person_param)
    location.href = url

  # Добавление контрагента
  do ->
    $mp_entity_fld = $('#contract_legal_entity_id')
    $mp_person_fld = $('#contract_contractor_id')
    opts = $.extend({}, tokenInputOptions, {
      hintText:    'Введите название, ОГРН, ИНН, КПП'
      prePopulate: $mp_entity_fld.data('pre')
    })
    $mp_entity_fld.tokenInput($mp_entity_fld.data('token-input-url'), opts)
    .change ()->
      $this = $(this)
      cond = parseInt($this.val()) > 0
      $('#add_new_entity_btn').toggle !cond
      $('#submit_btn').toggle cond
      return

    $mp_person_fld.change ->
      $this = $(this)
      cond = parseInt($this.val()) > 0
      $('#add_new_contractor_btn').toggle !cond
      $('#submit_btn').toggle cond
      return

    $('#contract_contract_type').change ->
      cond = ~~$(this).val() == 1
      $('#contractor_person').prop('disabled', !cond).toggle(cond)
      $('#contractor_entity').prop('disabled', cond).toggle(!cond)
      $('#add_new_contractor_btn').toggle(cond)
      $('#add_new_entity_btn').toggle(!cond)
      $('#submit_btn').hide()
      $mp_person_fld.change() if  cond && parseInt($mp_person_fld.val()) > 0
      $mp_entity_fld.change() if !cond && parseInt($mp_entity_fld.val()) > 0
      return
    .change()

    return

  load_operator_columns = (mp_id)->
    $('#left_operator_col').html('').load  "/left_column/0?med_program_id=#{mp_id}"
    $('#right_operator_col').html('').load "/right_column/0?med_program_id=#{mp_id}", ->
      $(".filestyle").filestyle({
        input: false,
        buttonText: "Выбрать отчет"
      })
    return

  return
