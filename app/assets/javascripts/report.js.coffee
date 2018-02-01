# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ -> 
  reportPage = $('#report-page')
  selectTherapy = $('#select_therapy')
  selectProgram = $('#select_program')

  sumbmitReport = $('#submit_report')

  $('.report-form__apply').click ->
    text = $('.report-form__textarea').val().replace(/\n/g, '<br/>');
    $('.report-form').html("<p>"+text+"</p>")

  if reportPage
    selectProgramInput = selectProgram.find 'input'
    selectTherapyInput = selectTherapy.find 'input'

    selectProgramInput.click () ->
      type = $(this).attr 'value'

      if type == 'continue_program'
        selectTherapy.removeClass 'hidden'
        sumbmitReport.attr 'disabled', true

      else
        selectTherapy.addClass 'hidden'
        sumbmitReport.attr 'disabled', false

    selectTherapyInput.click () ->
      sumbmitReport.attr 'disabled', false


  REPORT = $('form.report-form')
  EVENT_TYPE = REPORT.attr 'event'

  if REPORT.length

    if EVENT_TYPE == '33001' || EVENT_TYPE == '33010' || EVENT_TYPE == '33021'
      
      $wrongTask = $('#wrong-task')

      if $wrongTask.length
        $wrongTaskState = $('#upload_extras_error')
        $radios         = $wrongTask.find('input[type="radio"]')
        $artefact       = $('#upload_extras_error_event_artifact')
        $firstEffect    = $('#upload_extras_error_event_first_effect')
        $other          = $('#upload_extras_error_event_other')
        $comment        = $('.upload_extras_error_event_text')
        canSubmit       = true

        $wrongTask.hide()
        $comment.hide()

        $wrongTaskState.change ->
          $this = $(@)
          if $this.is(':checked')
            $wrongTask.show()
          else
            $wrongTask.hide()
            $radios.prop 'checked', false
            $comment.hide().find('input').val ''

        $radios.change ->
          $this = $(@).val()
          if $this == 'other'
            $comment.show()
          else
            $comment.hide().find('input').val ''
