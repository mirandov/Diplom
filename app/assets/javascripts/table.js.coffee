# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $table    = $('.table')

  $href     = $('.tr-href')
  $popover  = $('.tr-popover')

  if $table.length && ($href.length || $popover.length)

    if $href.length
      $tds = $table.find '.tr-href td'
      $tds.click ->
        $tr = $(this).parent 'tr'
        if $tr.data 'tab'
          window.open $tr.data 'link'
        else
          window.location = $tr.data 'link'
        return

    if $popover.length
      $tds = $table.find '.tr-popover td'

      $tds.on 'click', () ->
        $tr = $(this).parent 'tr.tr-popover'
        i   = $tr.attr 'index'
        $('.popover-buttons').fadeOut()
        $("#popover-buttons-#{i}").css
          top: $tr.position().top
          left: $tr.position().left
          width: $tr.width()
          height: $tr.height()

        $("#popover-buttons-#{i}").fadeIn()

      $('.popover-buttons').on 'click', () ->
        $('.popover-buttons').fadeOut()

# [!] if you've made the changes here, make the same in patients_list.js[~60] as well