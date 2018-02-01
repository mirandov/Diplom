# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  BSON = bson().BSON

  timezoneJS.timezone.zoneFileBasePath = '/tz';
  timezoneJS.timezone.defaultZoneFile = [];
  timezoneJS.timezone.init({async: false});

  ecgPage = $('#ecg_page')

  field = $('#graph_field')
  g = $('#ecg_graph-0')
  v = $('#ecg_viewer')
  status = $('.ecg_status')
  statusOffline = $('.ecg_status_offline')
  infoLive = $('.ecg_live_info')
  infoStatic = $('.ecg_static_info')
  plotSpeed = $('#ecg_speed')
  plotAmplitude = $('#ecg_amplitude')
  plotTime = $('.ecg_time')
  btnChangeSpeed = $('.change_ecg_speed')
  headerBtn = $('.navbar-nav').find('li')
  sessionsList = $('#session_list2')

  staticPlot = $('#ecg_graph_static')
  alarmTime = $('#alarm_time')
  outputTime = $('#output_time')

  liveBtn = $('#live-btn')
  staticBtn = $('#static-btn')
  liveTab = $('.tabs #live-tab')
  staticTab = $('.tabs #static-tab')

  pleaseWait = $('.please_wait')

  offlineViewer = $('#ecg_viewer_offline')

  ecgTabs = $('#tabs')
  ecgClear = $('#ecg_clear')

  alarmContainer = $('.ecg_window_alarm')
  alarmPageButtons = $('#alarm_buttons').find('a')

  heightOfScrollbar = 17

  gOptions =
    colors: ['#555','#FD1103']
    series:
      shadowSize: 0
      lines:
        lineWidth: 3
        show: true
    xaxis:
      show: false
    yaxis:
      show: false
      min: -100
      max: 100
    grid:
      borderWidth: 1
      hoverable: true
      clickable: true
      autoHighlight: false
    crosshair:
      mode: "x"

  vOptions =
    colors: ['#555','#FD1103']
    series:
      shadowSize: 0
      lines:
        lineWidth: 1.5
        show: true
    xaxis:
      show: false
    yaxis:
      show: false
      min: -3000
      max: 3000
    grid:
      borderWidth: 1
      hoverable: true
      clickable: true
      autoHighlight: false
      minBorderMargin: -10
    crosshair:
      mode: "x"

  blobToUint8Array = (blob, callback)->
    fileReader = new FileReader()

    fileReader.onload = ->
      callback new Uint8Array(this.result)
      return

    fileReader.readAsArrayBuffer(blob)

  getDate = (t) ->
    time = new Date(t)
    ('0' + time.getDate()).substr(-2) + '.' +
    ('0' + (time.getMonth() + 1)).substr(-2) + '.' +
    time.getFullYear() + ' в ' +
    ('0' + time.getHours()).substr(-2) + ':' +
    ('0' + time.getMinutes()).substr(-2) + ':' +
    ('0' + time.getSeconds()).substr(-2) + '.' +
    ('00' + time.getMilliseconds()).substr(-3)

  getTime = (t) ->
    time = new Date(t)
    ('0' + time.getHours()).substr(-2) + ':' +
    ('0' + time.getMinutes()).substr(-2) + ':' +
    ('0' + time.getSeconds()).substr(-2) + '.' +
    ('00' + time.getMilliseconds()).substr(-3)

  timeLine = (o) ->
    time = o.btime
    o.interval = (o.etime - o.btime) / (o.data.length - 1)
    result = []

    for value in o.data
      result.push [time, value]
      time += o.interval

    o.end_time = time
    result

  dataValues = (data_object) ->
    time = data_object.btime
    data_object.interval = (data_object.etime - data_object.btime) / (data_object.data.length - 1)
    result = []

    for value in data_object.data
      result.push [time, -10]
      time += data_object.interval

    data_object.end_time = time
    result

  # Преобразование полученных данных в данные графика
  transformData = (o, type) ->
    r = []
    time = o.btime
    o.interval = (o.etime - o.btime) / (o.data.length - 1)
    if type = 'v'
      for v in o.data
        r.push [time, v]
        time += o.interval
    else if type = 'g'
      for v in o.data
        r.push [time, -10]
        time +- o.interval
    o.end_time = time
    r

  # Определние количества секунд в графике
  setSize = (x) ->
    # Определение количества импульсов на ширину всего графика
    func = (e) ->
      numberOfSeconds = parseInt(e.children('.flot-base').attr('width'))/x
      y = numberOfSeconds * 1000

    if v.length
      func v
    else if staticPlot.length
      func staticPlot

  # Отображение информации о графике
  setInfo = (e, i) ->
    e.text i
    return

  # Получение информации о графике
  getInfo = (e, p, i) ->
    if p.x
      setInfo(plotTime, getTime(parseInt(p.x)))
    else
      setInfo(plotTime, "--:--:--.---")

  # Отображение статусного сообщения
  message = (e) ->

    text = () ->
      if e == 1
        status.text 'Идет накопление данных'
      else if e == 2
        status.text 'Данные передаются'
      else if e == 3
        status.text 'Передача данных остановлена'

    setTimeout text, 1000
    return

  if v.length
    playBtn = $('#ecg_online')
    data = []
    dInterval = 1
    currentAlarmID = null
    alarms = []
    plotID = 0
    
    gPlot = $.plot(g, [], gOptions)
    vPlot = $.plot(v, [], vOptions)
    v.bind 'plothover', getInfo

    gPlotData = []
    vPlotData = []
    gPlotAlarms = []
    vPlotAlarms = []
    gReceivedData = []
    vReceivedData = []
    obj = []
    startTime = 0
    checkStartTime = startTime
    timeInterval = 1
    gSize = 60 * 1000
    vSpeed = 125
    vSize = setSize vSpeed
    vQuantity = 6

    count = 5
    u = 0
    message 3

    # Установка времени на новом графике
    newTime = (i, t) ->
      i.parent().append '<div class=\'time-label\'>' + getTime(t) + '</div>'

    # Обновление времени на имеющемся графике
    updateTime = (i, t) ->
      time = i.parent().children().last()
      if time.attr('class') == 'time-label'
        time.text getTime(t)
      else
        newTime(i, t)

    # Создание нового графика
    newPlot = (i, t) ->
      i.parent().hide()
      plotID++
      graphID = "ecg_graph-#{plotID}"
      wrapperID = "ecg_graph_wrapper-#{plotID}"
      field.append("<div class=\"ecg_graph_wrapper\" id=\"#{wrapperID}\"><div class=\"ecg_graphic\" id=\"#{graphID}\"></div></div>")
      i = $("##{graphID}")
      gPlot = $.plot(i, [], gOptions)
      newTime(i, t)
      i

    # Смена скорости и надписи на кнопке
    changeSpeed = (text, b, s) ->
      btnChangeSpeed.children('span').text text
      btnChangeSpeed.value = b
      vSpeed = s
      vSize = setSize vSpeed

    btnChangeSpeed.click ->
      if btnChangeSpeed.value == 'slow'
        changeSpeed('25 мм/с', 'fast', 125)
      else
        changeSpeed('50 мм/с', 'slow', 250)

    disconnect = () ->
      message 3
      playBtn.data('online', false)
      btnChangeSpeed.prop('disabled', false)
      window.ecgAlarmController.disconnect()
      sessionsList.show()
      playBtn.children('span').removeAttr('class').addClass('glyphicon glyphicon-play')
      u = 0
      return

    # Отрисовка графика
    update = ->
      console.log 'update'
      c = count

      if u < 1000

        # Установка счетчика на накопление данных
        while c > 0

          # Есть ли данные, полученные до формирования графика
          if gReceivedData.length > 0
            console.log 'gReceivedData'

            # Переполнен ли график
            if gReceivedData[0][0] > gOptions.xaxis.max

              data.push gReceivedData.shift()

              gPlot.setData([gPlotData, gPlotAlarms])
              gPlot.draw()
              gPlotData = [gPlotData.pop()]
              
              g.parent().hide()

              gOptions.xaxis.min = gOptions.xaxis.max
              gOptions.xaxis.max = gOptions.xaxis.max + gSize

              plotID++
              graphID = "ecg_graph-#{plotID}"
              wrapperID = "ecg_graph_wrapper-#{plotID}"
              field.append("<div class=\"ecg_graph_wrapper\" id=\"#{wrapperID}\"><div class=\"ecg_graphic\" id=\"#{graphID}\"></div></div>")
              g = $("##{graphID}")
              gPlot = $.plot(g, [], gOptions)
              newTime(g, gOptions.xaxis.min)

              break

            u = 0
            gPlotData.push gReceivedData.shift()

          # Есть ли данные, полученные до формирования графика
          if vReceivedData.length > 0
            console.log 'vReceivedData'

            # Переполнен ли график
            if vReceivedData[0][0] > vOptions.xaxis.max

              vPlotData.push vReceivedData.shift()

              vPlot.setData([vPlotData, vPlotAlarms])
              vPlot.draw()
              vPlotData = [vPlotData.pop()]

              vOptions.xaxis.min = vOptions.xaxis.max
              vOptions.xaxis.max = vOptions.xaxis.max + vSize

              vPlot = $.plot(v, [], vOptions)

              break

            u = 0
            vPlotData.push vReceivedData.shift()
            infoLive.show()

          c--

        # Отрисовка графиков
        vPlot.setData([vPlotData, vPlotAlarms])
        gPlot.setData([gPlotData, gPlotAlarms])
        vPlot.draw()
        gPlot.draw()
        setTimeout update, dInterval if playBtn.data('online')

        # Отключил появление ошибки при отсутствии данных
        # u++

        if !playBtn.data('online')
          message 3

        else
          if gReceivedData.length > 0
            message 2

          else
            message 1

      else
        alert 'Превышен лимит ожидания приема данных от сервера: возможно телефон находится в режиме накопления данных или возникла ошибка при отправке данных с телефона.'
        disconnect()

    # Ожидание получения первого блока данных и формирование графика на основе полученных данных
    getBenigTime = ->

      # Выход из функции в случае остановки приема данных
      if playBtn.data('online')

        # Счетчик на определение времени простоя без получения данных
        if u < 100

          # Получен ли первый блок данных
          if startTime == checkStartTime
            setTimeout getBenigTime, 100
            u++

          else
            u = 0
            gOptions.xaxis.min = startTime
            gOptions.xaxis.max = startTime + gSize

            vOptions.xaxis.min = startTime
            vOptions.xaxis.max = startTime + vSize

            # Был ли запущен прием данных после остановки
            if gPlotData.length > 0
              gReceivedData = []
              gPlotData = []

              g.parent().hide()
              plotID++
              graphID = "ecg_graph-#{plotID}"
              wrapperID = "ecg_graph_wrapper-#{plotID}"
              field.append("<div class=\"ecg_graph_wrapper\" id=\"#{wrapperID}\"><div class=\"ecg_graphic\" id=\"#{graphID}\"></div></div>")
              g = $("##{graphID}")
              gPlot = $.plot(g, [], gOptions)
              newTime(g, startTime)

            else
              gPlot = $.plot(g, [], gOptions)
              updateTime(g, startTime)

            if vPlotData.length > 0
              vReceivedData = []
              vPlotData = []

              vPlot = $.plot(v, [], vOptions)
              # Отображение скорости бумаги
              setInfo plotSpeed, vSpeed/5

            else
              vPlot = $.plot(v, [], vOptions)
              # Отображение скорости бумаги
              setInfo plotSpeed, vSpeed/5

            # Прием данных и отрисовка графика
            setTimeout update, dInterval
            return

        else
          alert 'Превышен лимит ожидания приема данных от сервера: возможно телефон находится в режиме накопления данных или возникла ошибка при отправке данных с телефона.'
          disconnect()

      else
        message 3
        return

    # Начало приема данных
    play = () ->
      playBtn.prop('disabled', true)
      # sessionsList.hide()

      # Запущен ли в настоящий момент прием данных
      if !playBtn.data('online')
        playBtn.data('online', true)
        btnChangeSpeed.prop('disabled', true)

        # Соединение с сервером для получение данных
        window.ecgAlarmController = new ECG.Controller(window.ws_url, ecg_settings())

        # Задержка 6 сек после получения первого блока данных и последующая отрисовка данных на графике
        message 1
        setTimeout getBenigTime, 6000

        # Изменение кнопки Play на кнопку Stop
        playBtn.children('span').removeAttr('class').addClass('glyphicon glyphicon-stop')

        # Отключение WebSocket при нажатии на кнопки в header
        headerBtn.click () ->
          if ecgAlarmController
            window.ecgAlarmController.disconnect()
          return

      else
        startTime = 0
        disconnect()

      playBtn.prop('disabled', false)

    ecg_settings = ->
      settings =
        pid:     parseInt field.data 'med-program-id'
        height:  parseInt(v.children('.flot-base').attr('height'))
        pixels:  parseInt(parseInt(v.children('.flot-base').attr('width'))/(6/timeInterval))
        seconds: timeInterval
        url:     field.data 'ecg-server-url'

    class ECG.Controller
      defaultSettings: =>
        msgtype: 1,   #тип сообщения (для сообщения с настройками всегда 1)
        seconds: 5,   #длина интервала в секундах
        pixels: 850,  #длина отрезка в пикселях
        height: 150   #высота в пикселях

      constructor: (url, settings) ->
        console.log 'Сonstructor'
        $.extend @dataSettings = {}, @defaultSettings(), settings
        @dataSocket = new WebSocket(@dataSettings.url)
        @dispatcher = new WebSocketRails(url, true)

        @dispatcher.on_open = (data) ->
          # console.log 'Connection has been established: ', data
        @alarmChannel = @dispatcher.subscribe("ecg_alarm_#{@dataSettings.pid}")
        @events()

      events: =>
        console.log 'Events'
        @alarmChannel.bind 'sensorAlarm', @sensorAlarm

        @dataSocket.onopen = =>
          @dataSocket.send BSON.serialize @dataSettings
          console.log 'Opened'

        @dataSocket.onclose = (event) ->
          console.log 'Closed'

        @dataSocket.onmessage = (msg) ->
          console.log 'Getting Data...'
          window.test_blob = msg.data
          blobToUint8Array(msg.data, (arrayBuffer) ->
            obj = BSON.deserialize arrayBuffer
            vReceivedData = vReceivedData.concat timeLine obj
            gReceivedData = gReceivedData.concat dataValues obj
            startTime = obj.btime
            console.log obj
            dInterval = obj.interval #/5
          )

      sensorAlarm: (msg) ->
        console.log 'Alarm!'
        console.log msg
        alarms.push msg
        gPlotAlarms = gPlotAlarms.concat([[msg.occurred_at,gOptions.yaxis.max],
                                          [msg.occurred_at,gOptions.yaxis.min],
                                          [null]])
        vPlotAlarms = vPlotAlarms.concat([[msg.occurred_at,vOptions.yaxis.max],
                                          [msg.occurred_at,vOptions.yaxis.min],
                                          [null]])
        console.log alarms
        return

      disconnect: =>
        @dispatcher.disconnect()
        @dataSocket.close()
        console.log 'Disconnected'

    # Нажатие кнопки Play
    playBtn.click () ->
      play()

    # Автоматический запуск приема данных после загрузки страницы
    play()


  # Построение графика, для отображения статичных сессий
  if offlineViewer.length
    # ecgClear.prop('disabled', true)
    oPlot = $.plot(offlineViewer, [], vOptions)
    offlineViewer.bind 'plothover', getInfo
    alarmContainer.css 'height', parseInt(offlineViewer.children('.flot-base').attr('height')) + heightOfScrollbar

    # Задание длинны секунды графика в px
    sSpeed = 125

    seconds = 1

    # Определение нижней точки .nav-tabs
    ecgNavTabs = ecgPage.find('#ttop')
    console.log ecgNavTabs

    navTabsHeight = ecgNavTabs.height()
    navTabsTop = ecgNavTabs.offset().top
    navTabsBottom = navTabsTop + navTabsHeight + 2
    console.log navTabsBottom

    # Скрытие пустого графика, для отображения статусного сообщения
    offlineViewer.hide()

    # Имеются ли завершенные сессии
    if sessionsList.length

      # Отображение таблицы с сессиями
      $.get(window.sessions, med_program_id: item).done (table) ->
        # sessionsList.html(table).show()

        # # Определение высоты таблицы с учетом высоты экрана
        # windowHeight = $(window).height()
        # tablePosition = sessionsList.find('tbody').offset().top
        # tableHeight = windowHeight - 453
        # style =
        #   maxHeight: tableHeight

        # # Присвоение высоты таблице
        # sessionsList.find('tbody').css(style)

        # # Resize шапки таблицы с учетом ширины столбцов
        # table = sessionsList.find('table')
        # tableCells = table.find('tbody tr:first').children()

        # Выбор сессии
        $('tr.session').click ->

          statusOffline.text 'Идет прием данных'

          # Активна ли выбранная сессия
          # Исключение возможности выбирать сессию еще раз
          if $(this).hasClass('active_session')
            false

          else
            settings = (min, max, p) ->
              console.log 'Settings'
              settings =
                btime:    min
                etime:    max
                msgtype:  3
                pid:      parseInt offlineViewer.data 'med-program-id'
                rid:      1
                height:   parseInt offlineViewer.children('.flot-base').attr('height')
                pixels:   p
                url:      offlineViewer.data 'ecg-server-url'

              console.log settings

              dataSocket = new WebSocket(settings.url)

              dataSocket.onopen = =>
                console.log 'Opening...'
                dataSocket.send BSON.serialize settings
                console.log 'Opened'

              dataSocket.onclose = ->
                console.log 'Closed'

              dataSocket.onmessage = (msg) ->
                console.log 'Getting Data...'
                blobToUint8Array(msg.data, (arrayBuffer) ->
                  o = BSON.deserialize arrayBuffer
                  console.log 'Object = ', o
                  if o.rid == 1
                    offlineData = timeLine o

                    oPlot = $.plot(offlineViewer, [], vOptions)
                    oPlot.setData([offlineData, []])
                    oPlot.draw()

                    minT = o.end_time
                    maxT = minT + seconds * 1000
                    pixels = Math.floor seconds * sSpeed

                    dataSocket.close()

                    check minT, maxT, pixels, offlineData, duration
                  else
                    console.log 'Wrong Request ID'
                )

              # Открытие сокета для получения данных
              dataSocket.open

            check = (min, max, p, offlineData, duration) ->
              console.log 'duration ',duration
              if i < 1
                i++
                settings min, max, p
              else if i < duration
                i++
                percent = Math.round((i / duration) * 100)

                if percent > 100
                  percent = 100

                statusOffline.text 'Идет прием данных:' + ' ' + percent + '%'
                  
                console.log percent
                console.log 'Settings1'
                settings1 =
                  btime:    min
                  etime:    max
                  msgtype:  3
                  pid:      parseInt offlineViewer.data 'med-program-id'
                  rid:      1
                  height:   parseInt offlineViewer.children('.flot-base').attr('height')
                  pixels:   p
                  url:      offlineViewer.data 'ecg-server-url'

                console.log settings1

                dataSocket = new WebSocket(settings1.url)

                dataSocket.onopen = =>
                  console.log 'Opening...'
                  dataSocket.send BSON.serialize settings1
                  console.log 'Opened'

                dataSocket.onclose = ->
                  console.log 'Closed'

                dataSocket.onerror = ->
                  statusOffline.text 'Передача данных остановлена'
                  console.log 'Error'

                dataSocket.onmessage = (msg) ->
                  console.log 'Getting Data...'
                  blobToUint8Array(msg.data, (arrayBuffer) ->
                    obj = BSON.deserialize arrayBuffer
                    console.log 'Object = ', obj
                    if obj.rid == 1
                      datata = timeLine obj

                      offlineData = offlineData.concat datata

                      oPlot.setData([offlineData, []])
                      oPlot.draw()

                      minT = obj.end_time
                      maxT = minT + seconds * 1000
                      pixels = Math.floor seconds * sSpeed

                      dataSocket.close()

                      check minT, maxT, pixels, offlineData, duration

                    else
                      console.log 'Wrong Request ID'
                  )

                # Открытие сокета для получения данных
                dataSocket.open                          

              else
                alert 'Прием данных завершен'

                pleaseWait.hide()
                offlineViewer.show()
                infoStatic.show()

                return

            i = 0
            pleaseWait.show()
            offlineViewer.hide()
            infoStatic.hide()

            oPlot = $.plot(offlineViewer, [], vOptions)
            $('tr.session').removeClass('active_session')
            $(this).addClass('active_session')
            ecgClear.prop('disabled', false)

            # Нажатие на кнопку "Очистить"
            offlineViewer.click () ->
              oPlot = $.plot(offlineViewer, [], vOptions)
              infoStatic.hide()
              offlineViewer.hide()
              pleaseWait.show()
              statusOffline.text 'Выберите сессию'
              $('tr.session').removeClass('active_session')
              minTime = undefined
              maxTime = undefined
              # ecgClear.prop('disabled', true)
              return

            minTime = parseInt($(this).find('.start-t').text())
            maxTime = parseInt($(this).find('.finish-t').text())
            mm = minTime + seconds * 1000

            # Количество секунд
            duration = (maxTime - minTime) / 1000

            # Задание ширины графика
            offlineViewer.css 'width', sSpeed * duration

            vOptions.xaxis.min = minTime
            vOptions.xaxis.max = maxTime

            pixels = Math.floor seconds * sSpeed

            # Перемещение к нижней точке .nav-tabs
            $('html, body').animate {scrollTop : navTabsBottom}, 400

            check minTime, mm, pixels, [], duration

  liveBtn.click (e) ->
    e.preventDefault()
    $(this).tab 'show'

  staticBtn.click (e) ->
    e.preventDefault()
    $(this).tab 'show'

  # Для того чтобы static plot был сгенерирован в правильном размере
  ecgTabs.find('div:nth-child(2)').removeClass('active')

  # Resize шапки таблицы с учетом ширины столбцов   
  if !(table = undefined) && !(tableCells = [])
    $(window).resize( ->

      colWidth = tableCells.map( ->
        $(this).width()
      ).get()

      table.find('thead tr').children().each (i, v) ->
        $(v).width colWidth[i]
        return
      return

    ).resize()


  # Построение графика отображающего "Тревожную кнопку"
  if staticPlot.length
    dataLastTime = undefined
    dataDublucates = []
    dataArray = []
    errorMessage = undefined
    u = 0
    goOut = false

    # Опредение времени ожидания прихода всех данных в секундах
    waitingTime = 6

    # Получение времени "Тревожной кнопки"
    alarmTimeFormated = parseInt alarmTime.text()
    outputTime.text getDate(alarmTimeFormated)

    # Формирование графика и передача его высоты в alarmContainer
    # Для того чтобы контент под графиком не сдвигался вверх, во время отображения статусного сообщения
    # heightOfScrollbar - высота scrollbar под графиком
    sPlot = $.plot(staticPlot, [], vOptions)
    staticPlot.bind 'plothover', getInfo
    alarmContainer.css 'height', parseInt(staticPlot.children('.flot-base').attr('height')) + heightOfScrollbar

    # Задание длинны секунды графика в px
    sSpeed = 125

    # Задание количества секунд на графике
    numberOfSeconds = 20
    staticPlot.css 'width', sSpeed * numberOfSeconds

    # Задание ширины графика
    sSize = (numberOfSeconds * 1000) / 2

    # Задание времни начала и окончания графика
    minTime = parseInt(alarmTimeFormated) - sSize
    maxTime = parseInt(alarmTimeFormated) + sSize
    vOptions.xaxis.min = minTime
    vOptions.xaxis.max = maxTime

    # Настройки для WebSocket
    settings =
      btime:    minTime
      etime:    maxTime
      msgtype:  3
      pid:      parseInt staticPlot.data 'med-program-id'
      rid:      1
      height:   parseInt staticPlot.children('.flot-base').attr('height')
      pixels:   sSize
      url:      staticPlot.data 'ecg-server-url'

    console.log 'Settings = ', settings

    # Отрисовка тревожной кнопки
    alarm = [[alarmTimeFormated, vOptions.yaxis.max], [alarmTimeFormated, vOptions.yaxis.min]]
    sPlot = $.plot(staticPlot, [[], alarm], vOptions)

    # Скрытие пустого графика, для отображения статусного сообщения
    staticPlot.hide()

    # Функция отрисовки графика
    up = () ->

      # Получение текущего времени
      currentTime = (new Date).getTime()

      # Получили ли массив данных
      if dataLastTime

        # Отсуствует ли прямая линия на графике
        if dataDublucates.length == 0

          # Больше ли текущее время относительно последнего времени
          if currentTime >= dataLastTime

            # Флаг "Данные получены", для выхода из цикла
            goOut = true

            # Скрытие статусного сообщения и отображение прорисованного графика
            pleaseWait.hide()
            sPlot = $.plot(staticPlot, [data, alarm], vOptions)
            staticPlot.show()
            infoStatic.show()

            # Отображение графика с "Тревожной кнопкой" по центру
            plotWidth = parseInt staticPlot.children('.flot-base').attr('width')
            plotContainerWidth = alarmContainer.width()
            staticPlotWidth = plotWidth / 2 - plotContainerWidth / 2
            alarmContainer.scrollLeft(staticPlotWidth)
            return

          else
            u++
            errorMessage = 'Данные не полностью получены с сервера.'
            check()

        else
          u++
          errorMessage = 'Из полученных данных формируется прямая линия.'
          check()

      else
        u++
        errorMessage = 'Не удается подключиться к серверу.'
        check()


    # Функция получения данных с сервера по WebSocket
    socket = () ->
      console.log 'socket'
      data_socket = new WebSocket(settings.url)

      data_socket.onopen = =>
        console.log 'Opening...'
        data_socket.send BSON.serialize settings
        console.log 'Opened'
        message 1

      data_socket.onerror = ->
        message 3
        console.log 'Error'

      data_socket.onclose = ->
        message 3
        console.log 'Closed'

      data_socket.onmessage = (msg) ->
        console.log 'Getting Data...'
        blobToUint8Array(msg.data, (arrayBuffer) ->
          o = BSON.deserialize arrayBuffer
          console.log o
          dataArray = []

          if o.rid == 1
            data = timeLine o

            # Получение последнего времени массива данных
            dataLastTime = data[data.length - 1][0]

            # Формирование Array из "z" произвольных значений
            i = 0
            z = 20
            values = []
            while i < z
              random = Math.floor((Math.random() * 1000) + 1)
              value = data[data.length - random][1]
              values.push(value)
              i++

            # # Array для проверки
            # values = [12,12,12,13,13,12,13,11,13,13]

            # Сортировка выбранных значений по возрастанию
            valuesSorted = values.sort()
            console.log valuesSorted

            # Подсчет количества пофторяющихся значений в сформированном Array
            # Повторение до "x" раз не учитываются
            j = 0
            x = 3
            counter = 0
            current = null
            dataDublucates = []
            while j < valuesSorted.length
              if valuesSorted[j] == current
                counter++

              else
                if counter >= x
                  dataDublucates.push(counter)
                current = valuesSorted[j]
                counter = 1
              j++

            if counter >= x
              dataDublucates.push(counter)

            console.log 'dublicates = ', dataDublucates

            # Закрытие WebSocket
            data_socket.close()

            # Запуск функции отрисовки графика
            up()

          else
            console.log 'Wrong Request ID'
        )

      # Открытие WebSocket
      data_socket.open


    # Функция цикла
    check = () ->

      # Прошло ли waitingTime? Defautl: 6
      if u < waitingTime

        # Если флаг "Данные получены" еще не сработал
        if !goOut
          message 3
          setTimeout socket, 1000

      else
        message 3
        alert 'Не удается принять данные с сервера или сформировать из полученных данных график ЭКГ. Причина: ' + errorMessage
        return

    # Выход из цикла при переходе на другую страницу
    alarmPageButtons.click () ->
      goOut = true
    headerBtn.click () ->
      goOut = true

    # Первый запуск функции приема данных с сервера
    socket()

  return

window.ECG ?= {}