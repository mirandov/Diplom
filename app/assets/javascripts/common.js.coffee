# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  # Calculate the center of window for main menu
  header = $('header')
  footer = $('footer')
  menu = $('.main-menu-buttons')

  if menu.length
    headerHeight = header.outerHeight()
    height = $(window).height()
    menuHeight = menu.outerHeight()
    footerHeight = footer.outerHeight()

    area = height - headerHeight - footerHeight
    menuMargin = area / 2 - menuHeight / 2

    if menuMargin > 0
      menu.css 'margin-top', menuMargin

    $('.main-menu-button-wrapper').each ->
      $(this).click ->
        link = $(this).attr('data-link')
        if link.length
          window.open link, "_self"
          return

  # Block links on patient page to program page
  if $('#patient-page').length
    $('.program-block.activelink').click ->
      window.location = $(this).attr('data-link')
      return

  # Live search
  liveSearch = () ->
    liveSearch = $('.live-search')

    if liveSearch.length

      if $('.live-search-table').length
        options = 
          valueNames: [
            'live-search-field-1'
            'live-search-field-2'
          ]
          # Limit the page with 2000 items 
          page: 4000
        list = new List(liveSearch.attr('id'), options)

        $('.live-search-input').focus()

        if $('#number-of-items').length
          $('#number-of-items').text $('.list tr').length
      return   

  liveSearch()

  # Cookies for tabs
  tabsBlock = $('#tabs')
  navbar    = $('#nav')
  tabName   = $('#tab-name')

  if navbar.length and navbar.css('display') != 'none'
    changeTabName = (id) ->
      switch id
        when '0'
          'Неподписанные'
        when '1'
          'Выдача Комплектов'
        when '2'
          'Активные'
        when '3'
          'Не активные'
        when '4'
          'Архив' 

    links = navbar.find 'a'

    tabsBlock.tabs
      activate: (event, ui) ->
        linkId  = tabsBlock.tabs 'option', 'active'

        Cookies.set 'tab-selected', linkId
        Cookies.set 'tab-selected-id', links.eq(linkId).prop('href').slice(-1)
        return
      active: $('#tabs').tabs(active: Cookies.get('tab-selected'))

    _id = tabsBlock.tabs('option', 'active')

    active  = links.eq _id
    active.addClass 'active'

    links.each ->
      link = $(this)
      link.click ->
        links.removeClass 'active'
        link.addClass 'active'
        if tabName.length
          tabName.text changeTabName Cookies.get('tab-selected-id')

    if tabName.length
      tabName.text changeTabName links.eq(_id).prop('href').slice(-1)

  taskPage      = $('#task-page')

  # Prevent closing the task w/o action and comment
  if taskPage.length and taskPage.attr('task-type') == '33000'
    # first = $('#task_task_action_params_ad_red_zone_patient_control')
    # second = $('#task_task_action_params_ad_red_zone_call_fastaid')


    $(':submit').click ->
      if $(':radio').is ':checked'
        return
      else
        alert 'Выберите действие и введите комментарий.'
        false

  # Show name of the attachmed file
  attachment = $('#attachment')
  avatar = $('#avatar')
  uploadBnt = $('#upload-btn')

  attach = (elem) ->
    elem.change ->
      label = $(this).parent().find 'span'

      if typeof @files != 'undefined'

        if @files.length != 0
          f = @files[0]
          n = f.name
          label.addClass('withFile').text n

        else
          label.removeClass('withFile') label.data 'default'

      false
    return

  if avatar.length
    attach avatar

  if attachment.length
    uploadBnt.bind 'click', ->
      a = attachment.val()
      if a == ''
        alert 'Файл не выбран'
        false
      else
        return

    attach attachment

  # if $('#store-report').length
  $('.toggle-details').click ->
    $(this).next().toggleClass 'hidden'

  $('.toggle-table').click ->
    $(this).next().toggleClass 'hidden'

  # Prevent Modal from disappearing when clicking outside
  $('#closeProgram').modal({
    backdrop: 'static',
    keyword: false,
    show: false
  })

  if $('.values-table').length
    inputs = $('.values-table').find 'input'

    inputs.bind 'keydown', (e) ->
      input = $(this)

      if e.shiftKey || e.altKey ||
         e.keyCode != 8 && 
         e.keyCode != 9 &&
         e.keyCode != 0 &&
         e.keyCode != 46 &&
         (e.keyCode < 37 || e.keyCode > 40 && e.keyCode < 48 || e.keyCode > 57 && e.keyCode < 96 || e.keyCode > 105)
        e.preventDefault()
        false

  closeProgramModal = $('#close-program-modal')

  if closeProgramModal.length
    submit = closeProgramModal.find('input[type="submit"]')

    submit.click ->
      reason = $('#med_program_settings_close_reason').val().length
      comment = $('#med_program_settings_close_comment').val().length
      if reason && comment
        return
      else
        alert 'Заполните все поля'
        false

  if $('.radio').length && $('.radio').find('.radio-button').length
    radio = $('.radio')

    radio.click ->
      $(this).find('input').prop('checked', true)
      radio.removeClass('checked')
      $(this).addClass('checked')

  return