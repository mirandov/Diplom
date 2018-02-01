# Place here all the behaviors and hooks related to the application as a whole.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Using datepicker global
$ ->

  $inputGroup = $('.datepicker').parent('.input-group')

  if !$inputGroup.hasClass 'date'
    $inputGroup.addClass 'date'

  $inputGroup.datepicker
    format: 'dd.mm.yyyy'
    weekStart: 1
    language: 'ru'
    autoclose: true
    todayHighlight: true