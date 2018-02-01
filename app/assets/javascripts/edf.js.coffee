# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $edfBeginTime = $('#edf_begin_time')
  $edfEndTime = $('#edf_end_time')

  patinetID = $('#edf_patient_id')
  mpField = $('#edf_med_program_id')
  sessionsList = $('#session_list')

  $edfBeginTime.parent().append('<span class="edf_begin_time_remove edf_time_remove" title="Сбросить значение">×</span>')
  $edfEndTime.parent().append('<span class="edf_end_time_remove edf_time_remove" title="Сбросить значение">×</span>')

  removeBeginTime = $('.edf_begin_time_remove').hide()
  removeEndTime = $('.edf_end_time_remove').hide()

  $dateFields = $edfBeginTime.add $edfEndTime

  # Фильтр сессий не входящих в заданные временные промежутки
  showSessions = ->
    bt = $edfBeginTime.val().match(/(\d+).(\d+).(\d+) (\d+):(\d+):(\d+)/)
    et = $edfEndTime.val().match(/(\d+).(\d+).(\d+) (\d+):(\d+):(\d+)/)

    if bt || et
      currentBeginTime = new Date(bt[3],parseInt(bt[2])-1,bt[1],bt[4],bt[5],bt[6]).getTime() if bt
      currentEndTime = new Date(et[3],parseInt(et[2])-1,et[1],et[4],et[5],et[6]).getTime()+1000 if et

      list = $('tr.session')
      for e in list
        startTime = parseInt(e.children[1].children[1].textContent)
        finishTime = parseInt(e.children[2].children[1].textContent)

        if startTime && startTime < currentBeginTime || finishTime && finishTime > currentEndTime
          $(e).hide()

        else
          $(e).show()

  # Добавление нуля к цифрам в time
  f = (e) ->
    if e < 10
      e = '0' + e
    return e

  # Формат 'dd:mm:yyyy hh:mm:ss'
  time = (e) -> 
    f(e.getDate()) + '.' + f(e.getMonth() + 1) + '.' + e.getFullYear() + ' ' +
    f(e.getHours()) + ':' + f(e.getMinutes()) + ':' + f(e.getSeconds())

  # Формат 'dd:mm:yyyy'
  date = (e) ->
    f(e.getDate()) + '.' + f(e.getMonth() + 1) + '.' + e.getFullYear()

  optionTag = (val, name, selected = false)->
    """<option value="#{val}"#{selected && ' selected' || ''}>#{name}</option>"""

  tokenInputOptions = {
    crossDomain: false,
    hintText: "Введите фамилию, имя или отчество"
    noResultText: "Ничего не найдено",
    searchingText: "Поиск",
    preventDuplicates: true,
    propertyToSearch: 'full_name',
    minChars: 3,
    tokenLimit: 1
  }

  # Изменение в поле "Мед. программа"
  mpField.change ->
    $this = $(this)
    id = parseInt $this.val()
    $currentOption = $this.children('option:selected:first')

    # Выбрана ли мед. программа
    if id
      beginTime = $currentOption.data('begin_date')
      endTime   = $currentOption.data('end_date')

      # Вывод списка сессий
      $.get(window.sessions_path, med_program_id: id).done (html_str) ->
        sessionsList.html(html_str).show()

        top = sessionsList.find('tbody').offset().top
        windowHeight = $(window).height()
        tableHeight = windowHeight - top - 20 - 10 - 40 - 30

        style =
          maxHeight: tableHeight

        sessionsList.find('tbody').css(style)

        # Разблокировка полей для ввода даты и времени
        $dateFields.prop('disabled', false).each ->
          $(this).val('').parent('.input-group').
            addClass('date').
            datepicker('remove')
          return

        # Получение значения начала певой сессии и окончания последней
        BEGIN_TIME  = $('#session_list').find('tbody tr:first-child').find('td:eq(1) div:eq(0)').text()
        END_TIME    = $('#session_list').find('tbody tr:last-child').find('td:eq(2) div:eq(0)').text()

        # Приведение beginTime к общему формату вида 'dd:mm:yyyy hh:mm:ss'
        if !BEGIN_TIME
          beginTime = new Date(beginTime)
          beginTime.setHours 0, 0, 0
          BEGIN_TIME = time(beginTime)

        # Приведение endTime к общему формату вида 'dd:mm:yyyy hh:mm:ss'
        if !END_TIME
          endTime = new Date(endTime)
          endTime.setHours 0, 0, 0

          # Плюс сутки к endTime, если beginTime и endTime совпадают
          if $currentOption.data('begin_date') == $currentOption.data('end_date')
            endTime.setDate endTime.getDate() + 1

          END_TIME = time(endTime)

        # Заполнение полей для ввода даты и времени, временем начала и окончания мед. программы
        $edfBeginTime.val BEGIN_TIME
        $edfEndTime.val END_TIME

        # Добавление выбранного поля начала сессии в startTime
        sessionsList.on 'click', '.s_t', ->
          text = $(this).text()
          if !(text == BEGIN_TIME)
            $edfBeginTime.val(text).change()
            removeBeginTime.show()
          else
            false

        # Добавление выбранного поля завершения сессии в endTime
        sessionsList.on 'click', '.e_t', ->
          text = $(this).text()
          if !(text == END_TIME)
            $edfEndTime.val(text).change()
            removeEndTime.show()
          else
            false

        # Удаление выбранного startTime
        removeBeginTime.click () ->
          $edfBeginTime.val(BEGIN_TIME).change()
          removeBeginTime.hide()

        # Удаление выбранного endTime
        removeEndTime.click () ->
          $edfEndTime.val(END_TIME).change()
          removeEndTime.hide()

        # Resize шапки таблицы с учетом ширины столбцов
        table = sessionsList.find('table')
        tableCells = table.find('tbody tr:first').children()

        $(window).resize( ->

          colWidth = tableCells.map( ->
            $(this).width()
          ).get()

          table.find('thead tr').children().each (i, v) ->
            $(v).width colWidth[i]
            return
          return

        ).resize()

        # showSessions() if $edf_begin_time.val() || $edf_end_time.val()

    else
      # Скрытие списка сессий
      sessionsList.hide()

      # Блокировка полей для ввода даты и времени
      $dateFields.prop('disabled', true).each ->
        $(this).val('').parent('.input-group').datepicker('remove')
        return

    return

  .change()

  # Изменение в поле "Пациент"
  patinetID.tokenInput(
    patinetID.data('token-input-url'), $.extend({}, tokenInputOptions, {prePopulate: patinetID.data('pre')})
  ).change ->
    id = parseInt patinetID.val()

    # Введено ли имя пациента
    if id
      oldValue = mpField.data('value')

      # TODO: использовать для url-а хелпер?
      # Отображение мед. программ привязанных в id выбранного пациента
      $.ajax(url: "/patients/#{id}/med_programs.json", dataType: 'json').done (jsonArray) ->
        $options = $(optionTag('', ''))

        for mp in jsonArray

          # Отображение только ЭКГ
          if mp.template.supported_meterage[0] == 3112
            beginDate = new Date(mp.begin_date)
            bd = date beginDate
            $option = $(optionTag(mp.id, "#{mp.name} (#{bd || 'нет даты начала'})", oldValue == mp.id))
            $option.data('begin_date', mp.begin_date).data('end_date', mp.end_date)
            $options = $options.add $option

        mpField.html('').append($options)
        return

    else
      mpField.html('').change()

    return

  .change()

  # Вызов функции showSessions при изменении значений в полях даты и времени
  $dateFields.change showSessions

  return