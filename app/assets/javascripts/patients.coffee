# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  phoneBeginName = 'patient_mobile_phone_number'
  phoneNumEnd   = 'phone_number'
  phoneTypeEnd  = 'phone_type'

  phoneList = $('#phone-list')

  phoneMask = () ->
    phoneForm = $('.tel')
    phoneForm.mask '+7 (999) 999-99-99'

phoneMask()
