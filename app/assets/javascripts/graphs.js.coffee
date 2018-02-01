# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  # (($) ->
  #   $.fn.toggleDisabled = ->
  #     @each ->
  #       @disabled = !@disabled
  #       return
        
  #   return
  # ) jQuery
  
  $programPage = $('#program-page')
  $reportPage = $('#report-page')

  if $programPage.length || $reportPage.length

    build = () ->
      REPORT = $('form.report-form')
      EVENT_TYPE = REPORT.attr 'event'

      # $header = $('.header-report')

      # $header.click ->
      #   alert 'Event - ' + EVENT_TYPE

      $types = $('.types')

      weekSBP         = $('#week-SBP')
      weekDBP         = $('#week-DBP')
      weekHR          = $('#week-HR')

      yellowSBP       = $('#daily-yellow-SBP')
      yellowDBP       = $('#daily-yellow-DBP')
      yellowHR        = $('#daily-yellow-HR')

      nightSBP        = $('#night-SBP')
      nightDBP        = $('#night-DBP')
      nightHR         = $('#night-HR')

      morningSBP      = $('#morning-SBP')
      morningDBP      = $('#morning-DBP')
      morningHR       = $('#morning-HR')

      afternoonSBP    = $('#afternoon-SBP')
      afternoonDBP    = $('#afternoon-DBP')
      afternoonHR     = $('#afternoon-HR')

      eveningSBP      = $('#evening-SBP')
      eveningDBP      = $('#evening-DBP')
      eveningHR       = $('#evening-HR')

      averageSBP      = $('#average-SBP')
      averageDBP      = $('#average-DBP')
      averageHR       = $('#average-HR')

      $daypartCharts  = $('.daypart-chart')

      $nightChart     = $('.night-chart')
      $morningChart   = $('.morning-chart')
      $afternoonChart = $('.afternoon-chart')
      $eveningChart   = $('.evening-chart')

      $toggleButtons  = $('#toggle-buttons')
      $nightBtn       = $('#night-btn')
      $morningBtn     = $('#morning-btn')
      $afternoonBtn   = $('#afternoon-btn')
      $eveningBtn     = $('#evening-btn')

      $tableMaxSBP    = $('#table-max-sbp')
      $tableMixSBP    = $('#table-min-sbp')
      $tableMaxDBP    = $('#table-max-dbp')
      $tableMinDBP    = $('#table-min-dbp')
      $tableMaxHR     = $('#table-max-hr')
      $tableMinHR     = $('#table-min-hr')

      $tableAvgSBP    = $('#table-avg-sbp')
      $tableAvgDBP    = $('#table-avg-dbp')
      $tableAvgHR     = $('#table-avg-hr')

      $tableAvgNightSBP    = $('#table-avg-night-sbp')
      $tableAvgNightDBP    = $('#table-avg-night-dbp')
      $tableAvgNightHR     = $('#table-avg-night-hr')

      $tableAvgMorningSBP    = $('#table-avg-morning-sbp')
      $tableAvgMorningDBP    = $('#table-avg-morning-dbp')
      $tableAvgMorningHR     = $('#table-avg-morning-hr')

      $tableAvgAfternoonSBP    = $('#table-avg-afternoon-sbp')
      $tableAvgAfternoonDBP    = $('#table-avg-afternoon-dbp')
      $tableAvgAfternoonHR     = $('#table-avg-afternoon-hr')

      $tableAvgEveningSBP    = $('#table-avg-evening-sbp')
      $tableAvgEveningDBP    = $('#table-avg-evening-dbp')
      $tableAvgEveningHR     = $('#table-avg-evening-hr')


      $settings       = $('#graph-settings')

      if $settings.length
        tableHeader = $settings.find 'tbody tr:first tr'
        values = $settings.find 'td'

        settings =
          target:
            SBP:
              min: parseInt values[0].getAttribute 'target-data-min'
              max: parseInt values[0].getAttribute 'target-data-max'
            DBP:
              min: parseInt values[1].getAttribute 'target-data-min'
              max: parseInt values[1].getAttribute 'target-data-max'
            HR:
              min: parseInt values[2].getAttribute 'target-data-min'
              max: parseInt values[2].getAttribute 'target-data-max'
          critical:
            SBP:
              min: parseInt values[0].getAttribute 'critical-data-min'
              max: parseInt values[0].getAttribute 'critical-data-max'
            DBP:
              min: parseInt values[1].getAttribute 'critical-data-min'
              max: parseInt values[1].getAttribute 'critical-data-max'
            HR:
              min: parseInt values[2].getAttribute 'critical-data-min'
              max: parseInt values[2].getAttribute 'critical-data-max'

      typesLength = $('#types-size')

      unfoldRows = $('.show-all-rows')
      # Get the limit from HTML
      rowsLimit = unfoldRows.attr 'limit'

      foldRows = $('#hide-rows')
      foldRowsBlock = foldRows.parent 'div'

      foldRowsBlock.hide()

      datepicker = $('#datepicker')
      tableLength = $('#table-length')

      charts = $('.daytime-charts')
      
      oneSecond = 1000
      oneMinute = 60 * oneSecond
      oneHour   = 60 * oneMinute
      oneDay    = 24 * oneHour

      sixHours  = 6 * oneHour
      sixDays   = 6 * oneDay
      sevenDays = 7 * oneDay

      weekAgo = sixDays

      # Seven days on wholeday graphs
      if REPORT.length
        if EVENT_TYPE == '33010' || EVENT_TYPE == '33021'
          weekAgo = sevenDays
        else if EVENT_TYPE == '33100'
          weekAgo = sevenDays * 2
        else if EVENT_TYPE == '33200'
          weekAgo = sevenDays * 4 + oneDay * 2

      sixHoursArray = []
      daysArray = []
      # +1 - to see last day's values
      numberOfDays = weekAgo / oneDay + 1

      minSAD = undefined
      maxSAD = undefined
      minDAD = undefined
      maxDAD = undefined
      minHR = undefined
      maxHR = undefined
      label = []
      label[0] = ''
      label[1] = 'У'
      label[2] = 'Д'
      label[3] = 'В'

      localDate = new Date()
      localZone = - (localDate.getTimezoneOffset() / 60)
      moscowZome = 3
      differenceZone = (localZone - moscowZome) * 60 * 60 * 1000

      if differenceZone <= -25200000
        differenceZone = differenceZone + 86400000

      # Параметры графиков:
      # yMin - минимальное значение по оси y
      # yMax - максимальное значение по оси y
      # yTicks - горизонтальные линии по оси y
      # gridMarkings - разметка зон
      # xTicks - вертикальные линии по оси x, обозначающие утро, день, вечер

      makeBaseGraphOptions = (yMin, yMax, yTicks, gridMarkings, xTicks, xMin, xMax) ->
        options =
          series:
            lines:
              lineWidth: 2

            points:
              show: true
              radius: 4
              lineWidth: 2
            
            shadowSize: 3
            highlightColor: null

          legend:
            show: false
            noColumns: 2
            labelFormatter: null

          yaxis:
            min: yMin
            max: yMax
            ticks: yTicks

          xaxis:
            mode: "time"
            timeformat: "%d.%m"
            timezone: "browser"
            min: xMin
            max: xMax
            autoscaleMargin: 10
            ticks: xTicks
            tickColor: "#999"
            tickSize: [
              1
              'day'
            ]

          grid:
            backgroundColor:
              colors: [
                "#FFF"
                "#FFF"
              ]
            hoverable: true
            autoHighlight: true
            markings: gridMarkings
            markingsLineWidth: 1
            borderWidth: -1
            borderColor: '#BBB'
            mouseActiveRadius: 60

          canvas: true

      # Округление последней цифры числа по type
      round10 = (e, type) ->
        x = e.toString().split('e')
        x = Math[type](+(x[0] + 'e' + (if x[1] then +x[1] - 1 else -1)))
        x = x.toString().split('e')
        +(x[0] + 'e' + (if x[1] then +x[1] + 1 else 1))

      # Проверка, является ли значение больше, чем значение критического максимума или минимума
      checkMinMax = (limit, data, type) ->
        if limit != data
          x = round10 data, type
        else
          x = limit
        x

      # Задание вертикальных линий по оси Х, обозначающих время отображения показаний: Ночь, Утро, День, Вечер
      makeXMarkings = (o) ->
        length = o.length
        array = []
        i = 0

        while i < length
          e = []
          e =
            color: "#BDBDBD"
            xaxis:
              from: o[i]
              to: o[i]
          array.push e
          i++

        return array

      # Задание параметров для передачи в makeBaseGraphOptions
      makeGraphOptions = (tMin, tMax, cMin, cMax, dataMin, dataMax, array, xTicks, xMin, xMax) ->

        # Определение максимального и минимального значения
        gMin = checkMinMax(cMin, dataMin, 'floor')
        gMax = checkMinMax(cMax, dataMax, 'ceil')

        # 10 - отступ от максимального или минимального значения на графике
        yMin = parseInt(gMin) - 10
        yMax = parseInt(gMax) + 10

        # 10 - шаг сетки по оси y
        lines = (yMax - yMin) / 10

        # Задание координат разметки зон
        markings =       
          [ 
            { 
              color: "#FFF5C6" 
              yaxis:
                from: tMin
                to: cMin
            }
            { 
              color: "#FFD5D3" 
              yaxis:
                from: cMin
                to: yMin
            }
            { 
              color: "#FFF5C6"
              yaxis:
                from: tMax
                to: cMax
            }
            { 
              color: "#FFD5D3"
              yaxis:
                from: cMax
                to: yMax
            }
          ]

        # Вертикальная разметка по оси x
        xaxisArray = makeXMarkings array

        # Присоединение вертикальной разметки к горизонтальной, чтобы было одни массивом
        markings = markings.concat xaxisArray

        # Отступ, чтобы не пропадали lables у последних значений на графике
        if xMax <= 1000
          xMin = xMin - .5
          xMax = xMax - .5

        else if xMax >= 1000
          xMax = xMax + 100

        makeBaseGraphOptions yMin, yMax, lines, markings, xTicks, xMin, xMax

      # Задание параметров данных графика
      makeSeriesData = (dataArray, title, lineColor, fontColor, lines, points, hover, labels) ->
        labelsArray = []

        i = 0
        while i < dataArray.length
          labelsArray.push dataArray[i][1]
          i++

        if labels == undefined
          labels = true

        seriesData =
          color: lineColor
          data: dataArray
          labels: labelsArray
          label: title
          canvasRender: true
          showLabels: labels
          labelPlacement: "above"
          cColor: fontColor
          cFont: "14px Arial"
          cPadding: 4
          lines:
            show: lines
          points:
            symbol: points
          grid:
            hoverable: hover

      # Задание позиции и обозначения: Ночь, Утро, День, Вечер по оси Х
      makeLabels = (o, elem, graph) ->
        length = o.length
        i = 0

        while i < length
          j = 0
          while j < 4
            sim = elem.pointOffset
              x: o[i + j]
              y: 0
            graph.append '<div style="position: absolute; cursor: default; bottom: 0px; left: ' + (sim.left - 2) + 'px; font-size: 12px;">' + label[j] + '</div>'
            j++
          i = i + 4

      # Создание массива из времени начала каждого из 7 дней. Восьмое значение - начало восьмого дня - 
      # необходимо для того, чтобы седьмой день отображался целиком. 
      makeDaysArray = (end) ->

        date = new Date end
        date.setSeconds 0
        date.setMinutes 0
        date.setHours 0

        lastDay = Date.parse(date)
        day = lastDay - weekAgo
        i = 0

        while i < numberOfDays
          daysArray.push day
          day = day + oneDay
          i++

        lastDay = lastDay + oneDay
        daysArray.push lastDay
        daysArray

      # Создание массива времени из шестичасовых интервалов, для нанесения вертиральных линий на ось Х.
      makeSixHoursArray = (start, end) ->
        days = (Math.ceil (end - start) / 1000 / 60 / 60 / 24) + 1
        i = 0

        date = new Date start
        date.setSeconds 0
        date.setMinutes 0
        date.setHours 0

        day = Date.parse date

        while i < days
          sixHoursArray.push day
          sixHoursArray.push day + sixHours
          sixHoursArray.push day + sixHours * 2
          sixHoursArray.push day + sixHours * 3
          day = day + sixHours * 4
          i++

        sixHoursArray

      # Даты отображающиеся по оси X
      getDate = (t) ->
        time = new Date(t)
        ('0' + time.getDate()).substr(-2) + '.' +
        ('0' + (time.getMonth() + 1)).substr(-2)

      # Параметры всплывающего label
      showTooltip = (graph, i, l) ->
        # date - для дальнейшего, когда пойму как добавить дату в array
        dateString = ''
        xPosition = i.pageX - (16 + 10 * l)

        measurement = '<span class="tooltip-value text-center">' + i.datapoint[1] + '</span>'

        index = i.dataIndex
        date = i.series.data[index][2]

        if i.series.lines.show == false
          color = '#B94E46'
        else
          color = '#2B2A2A'

        if date
          dateString = '<hr><small>' + date + '</small><span class="tooltip-arrow">'
          xPosition = i.pageX - (16 + 34)

        $('<div id="tooltip" class="graph-tooltip">' + measurement + dateString + '</div>').css(
            'background-color': '#FFF'
            border: '1px solid #DDD'
            'border-radius': '4px'
            color: color
            cursor: 'default'
            display: 'none'
            'font-size': '15px'
            'font-weight': '500'
            left: xPosition
            opacity: '.9'
            padding: '3px'
            'pointer-events': 'none'
            position: 'absolute'
            'text-align': 'left'
            top: i.pageY - 14
            '-webkit-box-shadow': '0 0 6px 1px rgba(0, 0, 0, 0.4)'
            'box-shadow': '0 0 6px 1px rgba(0, 0, 0, 0.4)'
          ).appendTo('body').show()

      # Наведение на значение без label
      plotHover = (graph, array) ->
        if array.length
          graph.bind 'plothover', (event, pos, item) ->
            if item && previousPoint != item.datapoint
              previousPoint = item.datapoint
              $('#tooltip').remove()
              # l - the number of digits for the tooltip's position
              l = item.datapoint[1].toString().length
              showTooltip graph, item, l

            else
              $('#tooltip').remove()
              previousPoint = null

      getFormattedArray = (array) ->
        formatted = []
        devider = Math.floor array.length / 12

        if devider > 0
          length = array.length
          i = 0

          while i < length
            if i % devider == 0
              date = array[i][1]
            else
              date = ''

            formatted.push [
              i
              date
            ]
            i++

        else
          formatted = array

        formatted

      # Check nubmer of labels to show/hide them
      checkDataLength = (data) ->
        ret = true
        if data.length > 29
          ret = false
        ret

      # Отображение/скрытие строк в таблице
      toggleTableRows = (t, min, max) ->

        rows = t.find 'tbody tr'
        rowsFormatted = []

        if datepicker.length
          rowsFormatted = t.find('tbody tr').filter 'tr[display=true]'
          tableLength.text rowsFormatted.length

          if rowsFormatted.length <= rowsLimit
            foldRowsBlock.hide()
            unfoldRows.hide()
          else
            unfoldRows.show()

        else
          rowsFormatted = rows

        min = if min then min - 1 else 0
        max = if max then max else rows.length
        rows.hide()
        rowsFormatted.slice(min, max).show()
        false

      # Отображение/скрытие блока с графиками, в случае наличия/отсутствия графиков с данными
      toggleBlock = () ->
        buttons = $toggleButtons.find 'button'
        active = $toggleButtons.find '.active:enabled'

        if active.length == 0
          charts.addClass 'hidden'
          return

        else if charts.hasClass 'hidden'
          charts.removeClass 'hidden' 
          return
        return

      # Отображение/скрытие графика при нажатии кнопки относящейся к нему
      toggleByType = (type) ->
        switch type
          when 'night'
            $nightChart.toggleClass 'hidden'

          when 'morning'
            $morningChart.toggleClass 'hidden'

          when 'afternoon'
            $afternoonChart.toggleClass 'hidden'

          when 'evening'
            $eveningChart.toggleClass 'hidden'
        return

      toggleParts = () ->
        $toggleButtons.find('button').each ->
          $button = $(this)
          type = $button.data 'type'

          # Скрыть неактивный тип во время загруки страницы
          if !$button.hasClass 'active'
            switch type
              when 'night'
                $nightChart.addClass 'hidden'

              when 'morning'
                $morningChart.addClass 'hidden'

              when 'afternoon'
                $afternoonChart.addClass 'hidden'

              when 'evening'
                $eveningChart.addClass 'hidden'
         

      # Обработка нажатия на кнопки "Ночь", "Утро", "День", "Вечер"
      toggleButtons = () ->
        $toggleButtons.find('button').each ->
          $button = $(this)
          type = $button.data 'type'

          toggleBlock()

          $button.click ->
            $button.toggleClass 'active'

            toggleBlock()
            toggleByType(type)

      # Отключение кнопок при отсутствии измерений за период "Ночь", "Утро", "День", "Вечер"
      checkMeasurementsLength = (obj) ->
        if obj.night.data.length
          $toggleButtons.find('button[data-type="night"]').attr('disabled', false)
        else
          $toggleButtons.find('button[data-type="night"]').attr('disabled', true)

        if obj.morning.data.length
          $toggleButtons.find('button[data-type="morning"]').attr('disabled', false)
        else
          $toggleButtons.find('button[data-type="morning"]').attr('disabled', true)

        if obj.afternoon.data.length
          $toggleButtons.find('button[data-type="afternoon"]').attr('disabled', false)
        else
          $toggleButtons.find('button[data-type="afternoon"]').attr('disabled', true)

        if obj.evening.data.length
          $toggleButtons.find('button[data-type="evening"]').attr('disabled', false)
        else
          $toggleButtons.find('button[data-type="evening"]').attr('disabled', true)

      # Опредениение максмального значения
      limitMin = (v, min) ->
        # min = parseInt min
        if v < min
          v
        else
          min
        
      # Определение минимального значения
      limitMax = (v, max) ->
        # max = parseInt max
        if v > max
          v
        else
          max

      average = (array) ->
        if array.length
          i = 0
          sum = 0
          length = array.length

          while i < length
            sum += array[i]
            i++

          Math.round sum / length

        else
          '-'

      localTime = (time) ->
        if differenceZone != 0
          time = time - differenceZone
        time

      # Формирование массива данных на основании данных из всех перечисленных таблиц
      # ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
      # Таблица с реальными измерениями
      # Используется для выделения строк со значениями вне допустимых пределов
      $actualMeterages = $('#actual-meterages')
      actualMeteragesRows = $actualMeterages.find 'tbody tr'

      # Таблица значений за неделю
      $weekValues = $('#week-values')
      weekValuesRows = $weekValues.find 'td.time'

      # Таблица значений в красной зоне 
      $weekRedValues = $('#week-red-values')
      weekRedValuesRows = $weekRedValues.find 'tr'

      # Таблица со значимыми событиями
      $dailyYellowValues = $('#daily-yellow-values')
      dailyYellowValuesRows = $dailyYellowValues.find 'tr'

      # Таблица со значениями САД
      $dailyAverageSBP = $('#daily-average-sbp')
      dailyAverageRowsSBP = $dailyAverageSBP.find 'tr'

      # Таблица со значениями ДАД
      $dailyAverageDBP = $('#daily-average-dbp')
      dailyAverageRowsDBP = $dailyAverageDBP.find 'tr'

      # Таблица со значениями ЧСС
      $dailyAverageDBP = $('#daily-average-hr')
      dailyAverageRowsHR = $dailyAverageDBP.find 'tr'

      # Таблица с красными значениями САД
      $dailyRedSBP = $('#daily-red-sbp')
      dailyRedRowsSBP = $dailyRedSBP.find 'tr'

      # Таблица с красными значениями ДАД
      $dailyRedDBP = $('#daily-red-dbp')
      dailyRedRowsDBP = $dailyRedDBP.find 'tr'

      # Таблица с красными значениями ЧСС
      $dailyRedHR  = $('#daily-red-hr')
      dailyRedRowsHR = $dailyRedHR.find 'tr'

      redrawGraphs = () ->
        dayTimeSBP = {}
        dayTimeDBP = {}
        dayTimeHR  = {}
        nightTicks   = []
        morningTicks = []
        afternoonTicks = []
        eveningTicks = []

        SBP   = {}
        DBP   = {}
        HR    = {}
        ticks = []

        db = 
          SBP:
            data: []
            night: []
            morning: []
            afternoon: []
            evening: []
            avg: ->
              return average this.data
            min: ->
              if _.size this.data
                return Math.round _.min this.data
            max: ->
              if _.size this.data
                return Math.round _.max this.data

          DBP:
            data: []
            night: []
            morning: []
            afternoon: []
            evening: []
            avg: ->
              return average this.data
            min: ->
              if _.size this.data
                return Math.round _.min this.data
            max: ->
              if _.size this.data
                return Math.round _.max this.data

          HR:
            data: []
            night: []
            morning: []
            afternoon: []
            evening: []
            avg: ->
              return average this.data
            min: ->
              if _.size this.data
                return Math.round _.min this.data
            max: ->
              if _.size this.data
                return Math.round _.max this.data

        makeDayTimeObject = (min, max) ->
          options =
            night:
              data: []
              min: min
              max: max
            morning:
              data: []
              min: min
              max: max
            afternoon:
              data: []
              min: min
              max: max
            evening:
              data: []
              min: min
              max: max

        dayTimeSBP = makeDayTimeObject settings.critical.SBP.min, settings.critical.SBP.max
        dayTimeDBP = makeDayTimeObject settings.critical.DBP.min, settings.critical.DBP.max
        dayTimeHR  = makeDayTimeObject settings.critical.HR.min, settings.critical.HR.max

        # Array with values
        dayTimeArray = (rows, obj, arr) ->
          n = m = a = e = 0

          rows.each ->
            $this = $(this)
            tds = $this.find 'td'
            display = $this.attr 'display'

            tds.each ->
              td = $(this)
              type = td.attr 'class'
              data = Math.round parseFloat(td.text())
              date = getDate localTime parseInt td.data 'time'

              if display == 'true'
                switch type
                  when 'night'
                    arr.night.push data
                    obj.night.data.push [
                      n
                      data
                      date
                    ]
                    obj.night.min = limitMin data, obj.night.min
                    obj.night.max = limitMax data, obj.night.max
                    n++

                  when 'morning'
                    arr.morning.push data
                    obj.morning.data.push [
                      m
                      data
                      date
                    ]
                    obj.morning.min = limitMin data, obj.morning.min
                    obj.morning.max = limitMax data, obj.morning.max
                    m++

                  when 'afternoon'
                    arr.afternoon.push data
                    obj.afternoon.data.push [
                      a
                      data
                      date
                    ]
                    obj.afternoon.min = limitMin data, obj.afternoon.min
                    obj.afternoon.max = limitMax data, obj.afternoon.max
                    a++

                  when 'evening'
                    arr.evening.push data
                    obj.evening.data.push [
                      e
                      data
                      date
                    ]
                    obj.evening.min = limitMin data, obj.evening.min
                    obj.evening.max = limitMax data, obj.evening.max
                    e++

        dayTimeArray dailyAverageRowsSBP, dayTimeSBP, db.SBP
        dayTimeArray dailyAverageRowsDBP, dayTimeDBP, db.DBP
        dayTimeArray dailyAverageRowsHR,  dayTimeHR,  db.HR

        n = m = a = e = 0
        dailyAverageRowsSBP.each ->
          $this = $(this)
          tds = $this.find 'td'
          display = $this.attr 'display'

          tds.each ->
            td = $(this)
            type = td.attr 'class'
            date = getDate localTime parseInt td.data 'time'

            if display == 'true'
              switch type
                when 'night'
                  nightTicks.push [
                    n
                    date
                  ]
                  n++

                when 'morning'
                  morningTicks.push [
                    m
                    date
                  ]
                  m++

                when 'afternoon'
                  afternoonTicks.push [
                    a
                    date
                  ]
                  a++

                when 'evening'
                  eveningTicks.push [
                    e
                    date
                  ]
                  e++

        makePlot = (graph, data, tMin, tMax, cMin, cMax, yMin, yMax, sixHoursArray, daysArray, xMin, xMax, labels) ->
          hover = false
          output = []

          if data.red
            previousPoint = null
            plotHover graph, data.red

            output = makeSeriesData(data.red, '', '#EA6459', '#EA6459', false, 'diamond', true, false)
            data = data.data

          if !labels
            hover = true
            previousPoint = null
            plotHover graph, data

          if data.length
            $.plot(
              graph, 
              [
                makeSeriesData(data, '', '#383838', '#262626', true, 'circle', hover, labels),
                output
              ],
              makeGraphOptions(tMin, tMax, cMin, cMax, yMin, yMax, sixHoursArray, daysArray, xMin, xMax)
            )
          else
            graph.parent().hide()

        checkMeasurementsLength dayTimeSBP

        nightTicksFormatted = getFormattedArray nightTicks
        morningTicksFormatted = getFormattedArray morningTicks
        afternoonTicksFormatted = getFormattedArray afternoonTicks
        eveningTicksFormatted = getFormattedArray eveningTicks

        labelsNight = checkDataLength dayTimeSBP.night.data
        labelsMorning = checkDataLength dayTimeSBP.morning.data
        labelsAfternoon = checkDataLength dayTimeSBP.afternoon.data
        labelsEvening = checkDataLength dayTimeSBP.evening.data

        makePlot nightSBP,     dayTimeSBP.night.data,     settings.target.SBP.min, settings.target.SBP.max, settings.critical.SBP.min, settings.critical.SBP.max, dayTimeSBP.night.min,     dayTimeSBP.night.max,     sixHoursArray, nightTicksFormatted,     0, nightTicks.length, labelsNight
        makePlot morningSBP,   dayTimeSBP.morning.data,   settings.target.SBP.min, settings.target.SBP.max, settings.critical.SBP.min, settings.critical.SBP.max, dayTimeSBP.morning.min,   dayTimeSBP.morning.max,   sixHoursArray, morningTicksFormatted,   0, morningTicks.length, labelsMorning
        makePlot afternoonSBP, dayTimeSBP.afternoon.data, settings.target.SBP.min, settings.target.SBP.max, settings.critical.SBP.min, settings.critical.SBP.max, dayTimeSBP.afternoon.min, dayTimeSBP.afternoon.max, sixHoursArray, afternoonTicksFormatted, 0, afternoonTicks.length, labelsAfternoon
        makePlot eveningSBP,   dayTimeSBP.evening.data,   settings.target.SBP.min, settings.target.SBP.max, settings.critical.SBP.min, settings.critical.SBP.max, dayTimeSBP.evening.min,   dayTimeSBP.evening.max,   sixHoursArray, eveningTicksFormatted,   0, eveningTicks.length, labelsEvening
        makePlot nightDBP,     dayTimeDBP.night.data,     settings.target.DBP.min, settings.target.DBP.max, settings.critical.DBP.min, settings.critical.DBP.max, dayTimeDBP.night.min,     dayTimeDBP.night.max,     sixHoursArray, nightTicksFormatted,     0, nightTicks.length, labelsNight
        makePlot morningDBP,   dayTimeDBP.morning.data,   settings.target.DBP.min, settings.target.DBP.max, settings.critical.DBP.min, settings.critical.DBP.max, dayTimeDBP.morning.min,   dayTimeDBP.morning.max,   sixHoursArray, morningTicksFormatted,   0, morningTicks.length, labelsMorning
        makePlot afternoonDBP, dayTimeDBP.afternoon.data, settings.target.DBP.min, settings.target.DBP.max, settings.critical.DBP.min, settings.critical.DBP.max, dayTimeDBP.afternoon.min, dayTimeDBP.afternoon.max, sixHoursArray, afternoonTicksFormatted, 0, afternoonTicks.length, labelsAfternoon
        makePlot eveningDBP,   dayTimeDBP.evening.data,   settings.target.DBP.min, settings.target.DBP.max, settings.critical.DBP.min, settings.critical.DBP.max, dayTimeDBP.evening.min,   dayTimeDBP.evening.max,   sixHoursArray, eveningTicksFormatted,   0, eveningTicks.length, labelsEvening
        makePlot nightHR,      dayTimeHR.night.data,      settings.target.HR.min,  settings.target.HR.max,  settings.critical.HR.min,  settings.critical.HR.max,  dayTimeHR.night.min,      dayTimeHR.night.max,      sixHoursArray, nightTicksFormatted,     0, nightTicks.length, labelsNight
        makePlot morningHR,    dayTimeHR.morning.data,    settings.target.HR.min,  settings.target.HR.max,  settings.critical.HR.min,  settings.critical.HR.max,  dayTimeHR.morning.min,    dayTimeHR.morning.max,    sixHoursArray, morningTicksFormatted,   0, morningTicks.length, labelsMorning
        makePlot afternoonHR,  dayTimeHR.afternoon.data,  settings.target.HR.min,  settings.target.HR.max,  settings.critical.HR.min,  settings.critical.HR.max,  dayTimeHR.afternoon.min,  dayTimeHR.afternoon.max,  sixHoursArray, afternoonTicksFormatted, 0, afternoonTicks.length, labelsAfternoon
        makePlot eveningHR,    dayTimeHR.evening.data,    settings.target.HR.min,  settings.target.HR.max,  settings.critical.HR.min,  settings.critical.HR.max,  dayTimeHR.evening.min,    dayTimeHR.evening.max,    sixHoursArray, eveningTicksFormatted,   0, eveningTicks.length, labelsEvening

        # ––––––––––––––––––––––––––––––––––––––––––––

        if averageSBP.length
          makeDayObject = (min, max, name) ->
            options =
              el: name
              data: []
              red:  []
              min: min
              max: max

          SBP = makeDayObject settings.critical.SBP.min, settings.critical.SBP.max, averageSBP
          DBP = makeDayObject settings.critical.DBP.min, settings.critical.DBP.max, averageDBP
          HR  = makeDayObject settings.critical.HR.min,  settings.critical.HR.max,  averageHR

          # Array with values
          dayArray = (rows, redRows, obj) ->
            d = 0
            rows.each ->
              $this = $(this)
              tds = $this.find 'td'
              display = $this.attr 'display'
              date = getDate localTime parseInt tds.eq(0).data 'time'

              values = []

              if display == 'true'
                tds.each ->
                  td = $(this)
                  values.push parseFloat(td.text())

                data = average values

                obj.data.push [
                  d
                  data
                  date
                ]
                obj.min = limitMin data, obj.min
                obj.max = limitMax data, obj.max

                d++

            r = 0
            redRows.each ->
              $this = $(this)
              tds = $this.find 'td'
              display = $this.attr 'display'
              date = getDate localTime parseInt tds.eq(0).data 'time'

              if display == 'true'
                tds.each ->
                  td = $(this)
                  data = parseFloat td.text()

                  obj.red.push [
                    r
                    data
                    date
                  ]
                  obj.min = limitMin data, obj.min
                  obj.max = limitMax data, obj.max

                r++


          d = 0
          dailyAverageRowsSBP.each ->
            row = $(this)
            tds = row.find 'td'
            display = row.attr 'display'

            date = getDate localTime parseInt tds.eq(0).data 'time'

            if display == 'true'
              ticks.push [
                d
                date
              ]

              d++

          dayArray dailyAverageRowsSBP, dailyRedRowsSBP, SBP
          dayArray dailyAverageRowsDBP, dailyRedRowsDBP, DBP
          dayArray dailyAverageRowsHR,  dailyRedRowsHR,  HR

          ticksFormatted = getFormattedArray ticks

          labels = checkDataLength SBP.data

          makePlot SBP.el, SBP, settings.target.SBP.min, settings.target.SBP.max, settings.critical.SBP.min, settings.critical.SBP.max, SBP.min, SBP.max, sixHoursArray, ticksFormatted, 0, ticks.length, labels
          makePlot DBP.el, DBP, settings.target.DBP.min, settings.target.DBP.max, settings.critical.DBP.min, settings.critical.DBP.max, DBP.min, DBP.max, sixHoursArray, ticksFormatted, 0, ticks.length, labels
          makePlot HR.el,  HR,  settings.target.HR.min,  settings.target.HR.max,  settings.critical.HR.min,  settings.critical.HR.max,  HR.min,  HR.max,  sixHoursArray, ticksFormatted, 0, ticks.length, labels

          actualMeteragesRows.each ->
            $this = $(this)
            display = $this.attr 'display'

            if display == 'true'
              db.SBP.data.push parseFloat($this.find('td.sbp').text())
              db.DBP.data.push parseFloat($this.find('td.dbp').text())
              db.HR.data.push parseFloat($this.find('td.hr').text())

          $tableMaxSBP.text db.SBP.max()
          $tableMixSBP.text db.SBP.min()
          $tableMaxDBP.text db.DBP.max()
          $tableMinDBP.text db.DBP.min()
          $tableMaxHR.text db.HR.max()
          $tableMinHR.text db.HR.min()
          $tableAvgSBP.text db.SBP.avg()
          $tableAvgDBP.text db.DBP.avg()
          $tableAvgHR.text db.HR.avg()

          $tableAvgNightSBP.text average(db.SBP.night)
          $tableAvgNightDBP.text average(db.DBP.night)
          $tableAvgNightHR.text average(db.HR.night)
          $tableAvgMorningSBP.text average(db.SBP.morning)
          $tableAvgMorningDBP.text average(db.DBP.morning)
          $tableAvgMorningHR.text average(db.HR.morning)
          $tableAvgAfternoonSBP.text average(db.SBP.afternoon)
          $tableAvgAfternoonDBP.text average(db.DBP.afternoon)
          $tableAvgAfternoonHR.text average(db.HR.afternoon)
          $tableAvgEveningSBP.text average(db.SBP.evening)
          $tableAvgEveningDBP.text average(db.DBP.evening)
          $tableAvgEveningHR.text average(db.HR.evening)

          # Скрытие блоков в соответствии с нажатыми кнопками
          toggleParts()

      # Формирование графиков из талицы
      if $weekValues.length

        # Получение времени последнего измерения
        endTime = parseInt weekValuesRows.last().data('time')
        startTime = endTime - weekAgo

        makeDaysArray endTime
        makeSixHoursArray startTime, endTime

        minSAD = settings.critical.SBP.min
        maxSAD = settings.critical.SBP.max
        minDAD = settings.critical.DBP.min
        maxDAD = settings.critical.DBP.max
        minHR =  settings.critical.HR.min
        maxHR =  settings.critical.HR.max

        dataSAD = []
        dataDAD = []
        dataPulse = []

        redDataSAD = []
        redDataDAD = []
        redDataPulse = []

        weekValuesRows.each ->

          $this = $(this)
          time = localTime parseInt $this.data('time')
          SAD = Math.round parseFloat($this.next().text())
          DAD = Math.round parseFloat($this.next().next().text())
          pulse = Math.round parseFloat($this.next().next().next().text())

          # Не добавлять в array ночное значение первого дня
          if daysArray[0] != time
            # Arrays с данным для каждого из трех графиков
            dataSAD.push [
              time
              SAD
            ]
            dataDAD.push [
              time
              DAD
            ]
            dataPulse.push [
              time
              pulse
            ]

          # Определение минимальных и максимальных значений на графике
          minSAD = limitMin SAD, minSAD
          maxSAD = limitMax SAD, maxSAD
          minDAD = limitMin DAD, minDAD
          maxDAD = limitMax DAD, maxDAD
          minHR  = limitMin pulse, minHR
          maxHR  = limitMax pulse, maxHR
          true

        weekRedValuesRows.each ->

          tds = $(this).find 'td'

          tds.each ->
            td = $(this)
            time  = td.attr 'time'
            data = Math.round parseFloat td.text()

            switch td.attr 'type'
              when 'systolic_bp'
                minSAD = limitMin data, minSAD
                maxSAD = limitMax data, maxSAD
                redDataSAD.push [
                  time
                  data
                ]

              when 'diastolic_bp'
                minDAD = limitMin data, minDAD
                maxDAD = limitMax data, maxDAD
                redDataDAD.push [
                  time
                  data
                ]

              when 'heart_rate'
                minHR = limitMin data, minHR
                maxHR = limitMax data, maxHR
                redDataPulse.push [
                  time
                  data
                ]            

          true

        start = daysArray[0]
        end = daysArray[numberOfDays]

        # Графики за последние 7, 14, 30 дней
        if weekSBP.length
          hover = false
          labels = checkDataLength dataSAD ? true : false

          if !labels
            hover = true
            previousPoint = null
            plotHover weekSBP, dataSAD
            plotHover weekDBP, dataDAD
            plotHover weekHR,  dataPulse

          plotSAD = $.plot(
            weekSBP, 
            [
              makeSeriesData(dataSAD, tableHeader.filter(":eq(1)").text(), "#383838", "#262626", true, "circle", hover, labels)
              makeSeriesData(redDataSAD, tableHeader.filter(":eq(1)").text(), "#EA6459", "#EA6459", false, "diamond", true, false)
            ], 
            makeGraphOptions(settings.target.SBP.min, settings.target.SBP.max, settings.critical.SBP.min, settings.critical.SBP.max, minSAD, maxSAD, sixHoursArray, daysArray, start, end)
          )

          plotDAD = $.plot(
            weekDBP,
            [
              makeSeriesData(dataDAD, tableHeader.filter(":eq(2)").text(), "#383838", "#262626", true, "circle", hover, labels)
              makeSeriesData(redDataDAD, tableHeader.filter(":eq(1)").text(), "#EA6459", "#EA6459", false, "diamond", true, false)
            ],
            makeGraphOptions(settings.target.DBP.min, settings.target.DBP.max, settings.critical.DBP.min, settings.critical.DBP.max, minDAD, maxDAD, sixHoursArray, daysArray, start, end)
          )

          plotPulse = $.plot(
            weekHR, 
            [
              makeSeriesData(dataPulse, tableHeader.filter(":eq(3)").text(), "#383838", "#262626", true, "circle", hover, labels)
              makeSeriesData(redDataPulse, tableHeader.filter(":eq(1)").text(), "#EA6459", "#EA6459", false, "diamond", true, false)
            ], 
            makeGraphOptions(settings.target.HR.min, settings.target.HR.max, settings.critical.HR.min, settings.critical.HR.max, minHR, maxHR, sixHoursArray, daysArray, start, end)
          )

          if EVENT_TYPE != '33100' && EVENT_TYPE != '33200'
            # Add "У", "Д", "В" labels
            makeLabels sixHoursArray, plotSAD, weekSBP
            makeLabels sixHoursArray, plotDAD, weekDBP
            makeLabels sixHoursArray, plotPulse, weekHR

          previousPoint = null

          plotHover weekSBP, redDataSAD
          plotHover weekDBP, redDataDAD
          plotHover weekHR, redDataPulse

        # Графики со значимыми событиями
        if yellowSBP.length && $dailyYellowValues.length
          dayCounter = 0

          makeAlertsObject = (min, max) ->
            options =
              data: []
              min: min
              max: max

          makePlot = (graph, dataArray, tMin, tMax, cMin, cMax, yMin, yMax, sixHoursArray, daysArray, xMin, xMax, labels) ->
            hover = false

            if !labels
              hover = true
              previousPoint = null
              plotHover graph, dataArray

            $.plot(
              graph,
              [
                # dataArray, title, lineColor, fontColor, lines, points, hover, labels
                makeSeriesData(dataArray, "", "#D42729", "#262626", false, "circle", hover, labels)
              ],
              makeGraphOptions(tMin, tMax, cMin, cMax, yMin, yMax, sixHoursArray, daysArray, xMin, xMax)
            )

          alertsData = {
            SAD:   makeAlertsObject settings.critical.SBP.min, settings.critical.SBP.max
            DAD:   makeAlertsObject settings.critical.DBP.min, settings.critical.DBP.max
            HR:    makeAlertsObject settings.critical.HR.min, settings.critical.HR.max
            ticks: []
          }

          dailyYellowValuesRows.each (index) ->

            # Temporary array for calculating average values
            SAD = []
            DAD = []
            HR  = []

            $this = $(this)
            date = $this.attr('date').substr 0, 5
            tds = $this.find 'td'

            tds.each (i) ->
              td = $(this)
              value = td.text()

              if value.length
                data = Math.round parseFloat value

                checkAndPushData = (array, data, obj, t) ->
                  array.push data
                  obj.min = limitMin obj.min, data
                  obj.max = limitMax obj.max, data

                if i < 4
                  if data < settings.target.SBP.min or data > settings.target.SBP.max
                    checkAndPushData SAD, data, alertsData.SAD

                else if i < 8
                  if data < settings.target.DBP.min or data > settings.target.DBP.max
                    checkAndPushData DAD, data, alertsData.DAD, true

                else
                  if data < settings.target.HR.min or data > settings.target.HR.max
                    checkAndPushData HR, data, alertsData.HR

            averageDataSAD = average SAD
            averageDataDAD = average DAD
            averageDataHR  = average HR


            if averageDataSAD > 0 or averageDataDAD > 0 or averageDataHR > 0

              pushData = (data, obj) ->
                if data > 0
                  obj.data.push [
                    dayCounter
                    data
                  ]  

              pushData averageDataSAD, alertsData.SAD
              pushData averageDataDAD, alertsData.DAD
              pushData averageDataHR,  alertsData.HR

              alertsData.ticks.push [
                dayCounter
                date
              ]

              dayCounter++


          if alertsData.ticks.length
            formattedData = getFormattedArray alertsData.ticks

            labelsSAD = checkDataLength alertsData.SAD.data
            labelsDAD = checkDataLength alertsData.DAD.data
            labelsHR = checkDataLength alertsData.HR.data

            makePlot yellowSBP, alertsData.SAD.data, settings.target.SBP.min, settings.target.SBP.max, settings.critical.SBP.min, settings.critical.SBP.max, alertsData.SAD.min, alertsData.SAD.max, '', formattedData, 0, alertsData.ticks.length, labelsSAD
            makePlot yellowDBP, alertsData.DAD.data, settings.target.DBP.min, settings.target.DBP.max, settings.critical.DBP.min, settings.critical.DBP.max, alertsData.DAD.min, alertsData.DAD.max, '', formattedData, 0, alertsData.ticks.length, labelsDAD
            makePlot yellowHR,  alertsData.HR.data,  settings.target.HR.min,  settings.target.HR.max,  settings.critical.HR.min,  settings.critical.HR.max,  alertsData.HR.min,  alertsData.HR.max,  '', formattedData, 0, alertsData.ticks.length, labelsHR
          else
            graph = yellowSBP.parent().parent()
            graph.hide()

      # Выбор периода на странице "Мониторинг"
      if $('#datepicker').length && actualMeteragesRows.length
        startDate = $('#start_date')
        endDate = $('#end_date')

        $('.input-daterange').datepicker
          format: "dd.mm.yyyy"
          startDate: startDate.attr 'begin'
          endDate: endDate.val()
          weekStart: 1
          language: "ru"
          autoclose: true
          todayHighlight: true

        $(document).ready ->
          start = parseInt startDate.attr('unixtime')
          end = parseInt endDate.attr('unixtime')

          # Смена даты во всех заголовках
          changeDate = (date, range) ->
            $(range).text date

          # Измение значения unixtime при смене даты
          changeUnixtime = (field, range) ->
            time = parseInt field.datepicker('getDate').getTime()

            switch range
              when '.from'
                start = time

              when '.to'
                end = time = time + oneDay - 1

            field.attr 'unixtime', time
            changeDate field.val(), range
            return

          # Смена даты в заголовках при старте
          changeDate startDate.val(), '.from'
          changeDate endDate.val(), '.to'

          toggleRow = (row) ->
            time = Date.parse row.attr('date')

            if start <= time && time <= end
              row.attr 'display', true
            else
              row.attr 'display', false

            return

          (changeActualMeteragesRows = () ->
            if foldRowsBlock.css('display') != 'none'
              foldRowsBlock.hide()

            actualMeteragesRows.each ->
              $this = $(this)
              time = parseInt $this.attr('unixtime')

              if start <= time && time <= end 
                $this.attr 'display', true
              else
                $this.attr 'display', false

              return

            toggleTableRows $actualMeterages, 1, 10
            return
          )()

          (changeDailyAverageRows = () ->
            dailyAverageRowsSBP.each ->
              toggleRow $(this)

            dailyAverageRowsDBP.each ->
              toggleRow $(this)

            dailyAverageRowsHR.each ->
              toggleRow $(this)

            dailyRedRowsSBP.each ->
              toggleRow $(this)

            dailyRedRowsDBP.each ->
              toggleRow $(this)

            dailyRedRowsHR.each ->
              toggleRow $(this)

            return
          )() 

          # Изменение значения в поле "c"
          startDate.on 'hide', ->
            changeUnixtime $(this), '.from'
            changeActualMeteragesRows()
            changeDailyAverageRows()
            $daypartCharts.show()
            $daypartCharts.removeClass 'hidden'
            redrawGraphs()
            return

          # Изменение значения в поле "по"
          endDate.on 'hide', ->
            changeUnixtime $(this), '.to'
            changeActualMeteragesRows()
            changeDailyAverageRows()
            $daypartCharts.show()
            $daypartCharts.removeClass 'hidden'
            redrawGraphs()
            return

      # Графики по времени суток
      if $dailyAverageSBP.length
        $nightBtn.removeClass 'active'
        $afternoonBtn.removeClass 'active'
        redrawGraphs()
        toggleButtons()

      # Выделение значения, попавшего в красную зону
      if $actualMeterages.length
        actualMeteragesRows.each ->
          $this = $(this)
          tdSAD = $this.find 'td.sbp'
          tdDAD = $this.find 'td.dbp'
          tdPulse = $this.find 'td.hr'
          SAD = Math.round parseFloat(tdSAD.text())
          DAD = Math.round parseFloat(tdDAD.text())
          pulse = Math.round parseFloat(tdPulse.text())

          redRow = false

          if SAD < settings.critical.SBP.min || SAD > settings.critical.SBP.max
            tdSAD.find('span').addClass 'strong'
            redRow = true

          if DAD < settings.critical.DBP.min || DAD > settings.critical.DBP.max
            tdDAD.find('span').addClass 'strong'
            redRow = true

          if pulse < settings.critical.HR.min || pulse > settings.critical.HR.max
            tdPulse.find('span').addClass 'strong'
            redRow = true

          if redRow and !$this.hasClass 'warning'
            $this.addClass 'red-row'

          true

        $('.icon-alert-triangle').popover()

        # Отображение таблицы целиком в PDF-версии
        if unfoldRows.parent().css('display') == 'block'

          # Hide table rows with rowsLimit
          toggleTableRows $actualMeterages, 1, rowsLimit

          headerHeight = $('header').outerHeight()
          tableBottom = null

          unfolded = false
          
          # Unfold table action
          unfoldRows.click ->

            unfolded = true
            # Top position of the table
            tableTop = $actualMeterages.offset().top - headerHeight
            foldRowsBlock.fadeIn()
            toggleTableRows $actualMeterages
            $(this).hide()
            tableBottom = tableTop + $actualMeterages.outerHeight()

            (toggleButton = () ->
              if $(window).scrollTop() < tableTop || $(window).scrollTop() > tableBottom
                foldRowsBlock.fadeOut()
              else
                foldRowsBlock.fadeIn()
            )()

            $(window).scroll ->
              toggleButton()  if unfolded

            false

          foldRows.click ->
            unfolded = false
            unfoldRows.show()
            toggleTableRows $actualMeterages, 1, rowsLimit
            foldRowsBlock.fadeOut()
            false

      # ––––––––––––––––––––––––––––––––––––––––

      # Final Report with type blocks
      if $types.length
        $typesAverage = $('.types-average')

        tables = typesLength.text()
        t = 0

        while t < tables
          $tableSBP    = $("#daily-average-sbp-#{t}")
          rowsTableSBP = $tableSBP.find 'tr'

          $tableDBP    = $("#daily-average-dbp-#{t}")
          rowsTableDBP = $tableDBP.find 'tr'

          $tableHR     = $("#daily-average-hr-#{t}")
          rowsTableHR  = $tableHR.find 'tr'

          $tableRedSBP = $("#daily-red-sbp-#{t}")
          rowsTableRedSBP = $tableRedSBP.find 'tr'

          $tableRedDBP = $("#daily-red-dbp-#{t}")
          rowsTableRedDBP = $tableRedDBP.find 'tr'

          $tableRedHR = $("#daily-red-hr-#{t}")
          rowsTableRedHR = $tableRedHR.find 'tr'

          SBP    = {}
          DBP    = {}
          HR     = {}
          ticks  = []

          makeDayObject = (min, max, name) ->
            options =
              el: name
              data: []
              red:  []
              min: min
              max: max

          SBP = makeDayObject settings.critical.SBP.min, settings.critical.SBP.max, $types.find "#average-SBP-#{t}"
          DBP = makeDayObject settings.critical.DBP.min, settings.critical.DBP.max, $types.find "#average-DBP-#{t}"
          HR  = makeDayObject settings.critical.HR.min,  settings.critical.HR.max,  $types.find "#average-HR-#{t}"

          # Array with values
          dayArray = (rows, redRows, obj) ->
            d = 0
            rows.each ->
              $this = $(this)
              tds = $this.find 'td'
              display = $this.attr 'display'

              values = []

              tds.each ->
                td = $(this)
                values.push parseFloat(td.text())

              data = average values

              if display == 'true'
                obj.data.push [
                  d
                  data
                ]
                obj.min = limitMin data, obj.min
                obj.max = limitMax data, obj.max

                d++

            r = 0
            redRows.each ->
              $this = $(this)
              tds = $this.find 'td'
              display = $this.attr 'display'

              if display == 'true'
                tds.each ->
                  td = $(this)
                  data = parseFloat td.text()

                  obj.red.push [
                    r
                    data
                  ]
                  obj.min = limitMin data, obj.min
                  obj.max = limitMax data, obj.max
                r++

          d = 0
          rowsTableSBP.each ->
            row = $(this)
            tds = row.find 'td'
            display = row.attr 'display'

            date = getDate localTime parseInt tds.eq(0).data 'time'

            if display == 'true'
              ticks.push [
                d
                date
              ]

              d++

          dayArray rowsTableSBP, rowsTableRedSBP, SBP
          dayArray rowsTableDBP, rowsTableRedDBP, DBP
          dayArray rowsTableHR,  rowsTableRedHR,  HR

          makePlot = (graph, data, tMin, tMax, cMin, cMax, yMin, yMax, sixHoursArray, daysArray, xMin, xMax, labels) ->
            hover = false
            output = []

            if data.red
              previousPoint = null
              plotHover graph, data.red

              output = makeSeriesData(data.red, '', '#EA6459', '#EA6459', false, 'diamond', true, false)
              data = data.data

            if !labels
              hover = true
              previousPoint = null
              plotHover graph, data

            if data.length
              $.plot(
                graph, 
                [
                  makeSeriesData(data, '', '#383838', '#262626', true, 'circle', hover, labels),
                  output
                ],
                makeGraphOptions(tMin, tMax, cMin, cMax, yMin, yMax, sixHoursArray, daysArray, xMin, xMax)
              )
            else
              graph.parent().hide()

          ticksFormatted = getFormattedArray ticks

          labels = checkDataLength SBP.data

          makePlot SBP.el, SBP, settings.target.SBP.min, settings.target.SBP.max, settings.critical.SBP.min, settings.critical.SBP.max, SBP.min, SBP.max, sixHoursArray, ticksFormatted, 0, ticks.length, labels
          makePlot DBP.el, DBP, settings.target.DBP.min, settings.target.DBP.max, settings.critical.DBP.min, settings.critical.DBP.max, DBP.min, DBP.max, sixHoursArray, ticksFormatted, 0, ticks.length, labels
          makePlot HR.el,  HR,  settings.target.HR.min,  settings.target.HR.max,  settings.critical.HR.min,  settings.critical.HR.max,  HR.min,  HR.max,  sixHoursArray, ticksFormatted, 0, ticks.length, labels

          # –––––––––––––––––––––––

          dayTimeSBP = {}
          dayTimeDBP = {}
          dayTimeHR  = {} 

          makeDayTimeObject = (min, max, type) ->
            options =
              night:
                el: $("#night-#{type}-#{t}")
                data: []
                min: min
                max: max
              morning:
                el: $("#morning-#{type}-#{t}")
                data: []
                min: min
                max: max
              afternoon:
                el: $("#afternoon-#{type}-#{t}")
                data: []
                min: min
                max: max
              evening:
                el: $("#evening-#{type}-#{t}")
                data: []
                min: min
                max: max

          dayTimeSBP = makeDayTimeObject settings.critical.SBP.min, settings.critical.SBP.max, 'SBP'
          dayTimeDBP = makeDayTimeObject settings.critical.DBP.min, settings.critical.DBP.max, 'DBP'
          dayTimeHR  = makeDayTimeObject settings.critical.HR.min,  settings.critical.HR.max,  'HR'

          nightTicks   = []
          morningTicks = []
          afternoonTicks = []
          eveningTicks = []

          # Array with values
          dayTimeArray = (rows, obj) ->
            n = m = a = e = 0

            rows.each ->
              $this = $(this)
              tds = $this.find 'td'
              display = $this.attr 'display'

              tds.each ->
                td = $(this)
                type = td.attr 'class'
                data = Math.round parseFloat(td.text())

                if display == 'true'
                  switch type
                    when 'night'
                      obj.night.data.push [
                        n
                        data
                      ]
                      obj.night.min = limitMin data, obj.night.min
                      obj.night.max = limitMax data, obj.night.max
                      n++

                    when 'morning'
                      obj.morning.data.push [
                        m
                        data
                      ]
                      obj.morning.min = limitMin data, obj.morning.min
                      obj.morning.max = limitMax data, obj.morning.max
                      m++

                    when 'afternoon'
                      obj.afternoon.data.push [
                        a
                        data
                      ]
                      obj.afternoon.min = limitMin data, obj.afternoon.min
                      obj.afternoon.max = limitMax data, obj.afternoon.max
                      a++

                    when 'evening'
                      obj.evening.data.push [
                        e
                        data
                      ]
                      obj.evening.min = limitMin data, obj.evening.min
                      obj.evening.max = limitMax data, obj.evening.max
                      e++


          dayTimeArray rowsTableSBP, dayTimeSBP
          dayTimeArray rowsTableDBP, dayTimeDBP
          dayTimeArray rowsTableHR,  dayTimeHR

          n = m = a = e = 0
          rowsTableSBP.each ->
            $this = $(this)
            tds = $this.find 'td'
            display = $this.attr 'display'

            tds.each ->
              td = $(this)
              type = td.attr 'class'
              date = getDate localTime parseInt td.data 'time'

              if display == 'true'
                switch type
                  when 'night'
                    nightTicks.push [
                      n
                      date
                    ]
                    n++

                  when 'morning'
                    morningTicks.push [
                      m
                      date
                    ]
                    m++

                  when 'afternoon'
                    afternoonTicks.push [
                      a
                      date
                    ]
                    a++

                  when 'evening'
                    eveningTicks.push [
                      e
                      date
                    ]
                    e++

          nightTicksFormatted = getFormattedArray nightTicks
          morningTicksFormatted = getFormattedArray morningTicks
          afternoonTicksFormatted = getFormattedArray afternoonTicks
          eveningTicksFormatted = getFormattedArray eveningTicks

          labelsNight = checkDataLength dayTimeSBP.night.data
          labelsMorning = checkDataLength dayTimeSBP.morning.data
          labelsAfternoon = checkDataLength dayTimeSBP.afternoon.data
          labelsEvening = checkDataLength dayTimeSBP.evening.data

          makePlot dayTimeSBP.night.el,     dayTimeSBP.night.data,     settings.target.SBP.min, settings.target.SBP.max, settings.critical.SBP.min, settings.critical.SBP.max, dayTimeSBP.night.min,     dayTimeSBP.night.max,     sixHoursArray, nightTicksFormatted,     0, nightTicks.length, labelsNight
          makePlot dayTimeSBP.morning.el,   dayTimeSBP.morning.data,   settings.target.SBP.min, settings.target.SBP.max, settings.critical.SBP.min, settings.critical.SBP.max, dayTimeSBP.morning.min,   dayTimeSBP.morning.max,   sixHoursArray, morningTicksFormatted,   0, morningTicks.length, labelsMorning
          makePlot dayTimeSBP.afternoon.el, dayTimeSBP.afternoon.data, settings.target.SBP.min, settings.target.SBP.max, settings.critical.SBP.min, settings.critical.SBP.max, dayTimeSBP.afternoon.min, dayTimeSBP.afternoon.max, sixHoursArray, afternoonTicksFormatted, 0, afternoonTicks.length, labelsAfternoon
          makePlot dayTimeSBP.evening.el,   dayTimeSBP.evening.data,   settings.target.SBP.min, settings.target.SBP.max, settings.critical.SBP.min, settings.critical.SBP.max, dayTimeSBP.evening.min,   dayTimeSBP.evening.max,   sixHoursArray, eveningTicksFormatted,   0, eveningTicks.length, labelsEvening
          makePlot dayTimeDBP.night.el,     dayTimeDBP.night.data,     settings.target.DBP.min, settings.target.DBP.max, settings.critical.DBP.min, settings.critical.DBP.max, dayTimeDBP.night.min,     dayTimeDBP.night.max,     sixHoursArray, nightTicksFormatted,     0, nightTicks.length, labelsNight
          makePlot dayTimeDBP.morning.el,   dayTimeDBP.morning.data,   settings.target.DBP.min, settings.target.DBP.max, settings.critical.DBP.min, settings.critical.DBP.max, dayTimeDBP.morning.min,   dayTimeDBP.morning.max,   sixHoursArray, morningTicksFormatted,   0, morningTicks.length, labelsMorning
          makePlot dayTimeDBP.afternoon.el, dayTimeDBP.afternoon.data, settings.target.DBP.min, settings.target.DBP.max, settings.critical.DBP.min, settings.critical.DBP.max, dayTimeDBP.afternoon.min, dayTimeDBP.afternoon.max, sixHoursArray, afternoonTicksFormatted, 0, afternoonTicks.length, labelsAfternoon
          makePlot dayTimeDBP.evening.el,   dayTimeDBP.evening.data,   settings.target.DBP.min, settings.target.DBP.max, settings.critical.DBP.min, settings.critical.DBP.max, dayTimeDBP.evening.min,   dayTimeDBP.evening.max,   sixHoursArray, eveningTicksFormatted,   0, eveningTicks.length, labelsEvening
          makePlot dayTimeHR.night.el,      dayTimeHR.night.data,      settings.target.HR.min,  settings.target.HR.max,  settings.critical.HR.min,  settings.critical.HR.max,  dayTimeHR.night.min,      dayTimeHR.night.max,      sixHoursArray, nightTicksFormatted,     0, nightTicks.length, labelsNight
          makePlot dayTimeHR.morning.el,    dayTimeHR.morning.data,    settings.target.HR.min,  settings.target.HR.max,  settings.critical.HR.min,  settings.critical.HR.max,  dayTimeHR.morning.min,    dayTimeHR.morning.max,    sixHoursArray, morningTicksFormatted,   0, morningTicks.length, labelsMorning
          makePlot dayTimeHR.afternoon.el,  dayTimeHR.afternoon.data,  settings.target.HR.min,  settings.target.HR.max,  settings.critical.HR.min,  settings.critical.HR.max,  dayTimeHR.afternoon.min,  dayTimeHR.afternoon.max,  sixHoursArray, afternoonTicksFormatted, 0, afternoonTicks.length, labelsAfternoon
          makePlot dayTimeHR.evening.el,    dayTimeHR.evening.data,    settings.target.HR.min,  settings.target.HR.max,  settings.critical.HR.min,  settings.critical.HR.max,  dayTimeHR.evening.min,    dayTimeHR.evening.max,    sixHoursArray, eveningTicksFormatted,   0, eveningTicks.length, labelsEvening

          t++

      return

    $('#ui-id-1').click ->
      build()

    build()
    return
