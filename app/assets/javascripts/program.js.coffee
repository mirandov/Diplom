# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  $programPage = $('#program-page')

  if $programPage.length
    $('#btn-print').click ->
      window.print()
      false

    $history = $('#tab5')
    $nav = $('#nav')

    if $history.length
      options = {
        valueNames: [
          'id'
        ]
      }
      historyList = new List 'program-history', options
      historyList.sort 'id', { order: 'desc' }

    if $nav.length
      marginTop = 35
      marginLeft = 15
      navOffsetTop = $nav.offset().top - marginTop
      navOffsetLeft = $nav.offset().left + marginLeft
      navWidth = $nav.width()

      $(window).scroll () ->
        pos = $(window).scrollTop()

        if pos > navOffsetTop
          $nav.css
            'left':     navOffsetLeft
            'position': 'fixed'
            'top':      marginTop
            'width':    navWidth
        else
          $nav.css
            'position': 'relative'
            'width':    'auto'
            'left':     0
            'top':      0