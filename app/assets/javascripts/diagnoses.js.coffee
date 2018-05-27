# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $add  = $('#new-diagnosis')


  host  = $(location).attr 'origin'


  getComplictation = (class_diseaseId, complictationId, blank) ->
    blank ||= ''
    $complictation.find('option').remove()

    link = host + '/complictations?class_disease=' + class_diseaseId

    $.getJSON link, (complictations) ->
      if complictations
        opts = []
        opts.push '<option value>' + blank + '</option>'
        _.each complictations, (complictation) ->
          if complictation.class_disease_id == parseInt(class_diseaseId)

            opts.push """<option value='#{complictation.id}'>#{complictation.name}</option>"""


        $complictation.append opts
        if complictationId
          $complictation.val complictationId


  if $add.length
    $class_disease    = $('#diagnosis_class_disease_id')
    $complictation    = $('#diagnosis_complictation_id')

    if $class_disease.val().length
     complictationId = if $complictation.val().length then $complictation.val() else false
     getComplictation $class_disease.val(), complictationId
    else
     $complictation.find('option').remove()

    $class_disease.change ->
     value = $(this).val()
     getComplictation value, false
