# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# commented at May 24th
# $ ->
#   do ->
#     new_form = $('#new_user')
#     # if have no 'new' form, search for 'edit' form
#     new_form = $("form[id^='edit_user_']") if new_form.length < 1

#     $("input[name='user[assignments_attributes][][role_id]']", new_form).change ->

#       # Скрываем данные пациента, если они не нужны
#       # FIXME: hardcoded id (3) - пациент
#       checked = $('#user_role_ids_3').prop('checked')
#       $('#patient_data').prop('disabled', !checked).toggle(checked)

#       # Скрываем данные врача, если они не нужны
#       # FIXME: hardcoded id (2) - врач
#       checked = $('#user_role_ids_2').prop('checked')
#       $('#doctor_data').prop('disabled', !checked).toggle(checked)

#       return
#     .change()

#     return
