# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->

  urls =
    '3082': 'tonometry_datum'
    '3092': 'blood_clotting'
    '3112': 'ecg_aatos'

  get_fields_for = (name)->
    $.ajax(
      url: "/med_program_templates/#{name}"
      dataType: 'html'
    ).done( (data)->
      $("#meterage_fields").html data
      return
    ).fail ->
      alert "ajax failed!"
      return
    return

  $("#meterage").change( ->
    get_fields_for urls[this.value]
    return
  ).change()

  mp_prefix = "input[type='checkbox'][name^='med_program']"
  checkbox_selectors = "#{mp_prefix}[name$='[need_notify]'], #{mp_prefix}[name$='[need_notify_expired]']"

  $("#meterage_fields").on 'change', checkbox_selectors, ->
    $this = $(this)
    $this.parent().next('input').prop('disabled', !$this.prop('checked'))
    return

  $(checkbox_selectors).change()

  return
