# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  timezoneJS.timezone.zoneFileBasePath = "/tz";
  timezoneJS.timezone.defaultZoneFile = [];
  timezoneJS.timezone.init({async: false});

  make_baseGraphOptions = (yMin, yMax, yTicks, gridMarkings) ->
    options =
      series:
        highlightColor: null
        lines:
          lineWidth: 2
          show: true
        points:
          lineWidth: 2
          radius: 4
          show: true
        shadowSize: 0
      legend:
        # container: '#blood_press_graph_labels'
        labelFormatter: null
        noColumns: 2
        show: true
      xaxis:
        mode: "time"
        timeformat: "%d.%m"
        timezone: "Europe/Moscow"
        autoscaleMargin: 0.01
        tickColor: "#DDD" # vertical grid ticks color
        minTickSize: [1, 'day']
      yaxis:
        min: yMin
        max: yMax
        ticks: yTicks
      grid:
        hoverable: true
        autoHighlight: true
        markings: gridMarkings,
        borderWidth: 0
        mouseActiveRadius: 60
    options

  make_pressureGraphOptions = ->
    make_baseGraphOptions 20, 200, 10,
      [
        {
          yaxis:
            from: norms_dad_min
            to: norms_dad_min
          color: '#BABABA'
        }
        {
          yaxis:
            from: norms_dad_max
            to: norms_dad_max
          color: '#BABABA'
        }
        {
          yaxis: 
            from: norms_sad_min
            to: norms_sad_min
          color: '#383838'
        }
        {
          yaxis:
            from: norms_sad_max
            to: norms_sad_max
          color: '#383838'
        }
      ]

  make_pulseGraphOptions = ->
    make_baseGraphOptions 40, 120, 8, 
      [
        {
          yaxis:
            from: norms_pulse_min
            to: norms_pulse_min
          color: '#858585'
        }
        {
          yaxis:
            from: norms_pulse_max
            to: norms_pulse_max
          color: '#858585'
        }
      ]

  make_seriesData = (dataArray, title, lineColor, fontColor) ->
    i = 0
    labelsArray = []

    while i < dataArray.length
      labelsArray.push dataArray[i][1]
      i++

    seriesData = 
      data: dataArray
      labels: labelsArray
      label: title
      canvasRender: true
      showLabels: true
      labelPlacement: 'above'
      color: lineColor
      cColor: fontColor
      cFont: '13px Arial'
      cPadding: 4
    seriesData

  graph = $("#blood_press_graph")
  pulse_graph = $("#pulse_graph")

  if graph.length # exists?

    table_data  = $('#hidden_meterage_table td.time')
    data_length = table_data.length

    if data_length

      # Store values for flot here:
      s_data = []
      d_data = []
      p_data = []

      table_data.each ()->
        $this = $(this)
        time  = parseInt($this.data('time'))
        sbp   = $this.next()
        dbp   = sbp.next()
        pulse = dbp.next()
        # time must be an UTC!
        s_data.push([time, parseInt(  sbp.text())])
        d_data.push([time, parseInt(  dbp.text())])
        p_data.push([time, parseInt(pulse.text())])

      norms = $('#hidden_meterage_table th')
      norms_sad_min = norms[1].getAttribute('data-min')
      norms_sad_max = norms[1].getAttribute('data-max')
      norms_dad_min = norms[2].getAttribute('data-min')
      norms_dad_max = norms[2].getAttribute('data-max')
      norms_pulse_min = norms[3].getAttribute('data-min')
      norms_pulse_max = norms[3].getAttribute('data-max')

      table_header = $("#hidden_meterage_table thead tr:first th")
      plot = $.plot(graph, [
        make_seriesData(s_data, table_header.filter(":eq(1)").text(), "#383838", "#262626"),
        make_seriesData(d_data, table_header.filter(":eq(2)").text(), "#787878", "#5C5C5C")
      ], make_pressureGraphOptions())

      # # Формат отображения содержимого подсказки (при наведении мыши):
      # # значение + дата и время (на следующей строке).
      # formatter = (data) ->
      #   timestamp = table_data.filter("[data-time=#{data[0]}]:first").text()
      #   "<div class='text-center'>#{data[1].toFixed(2)}</div>#{timestamp}"

      # graph.set_tooltip({pos_y: -5}, formatter)

      if pulse_graph.length
        # pulse_opts = $.extend true, {}, graph_options
        # pulse_opts.legend.container = '#pulse_graph_labels'
        p_plot = $.plot(pulse_graph, [
          make_seriesData(p_data, table_header.filter(":eq(3)").text(), "#343434", "#2B2B2B")
        ], make_pulseGraphOptions())

        # pulse_graph.set_tooltip({pos_y: -5}, formatter)

      # ::toDO-legan
      o1 = plot.pointOffset(
        x: 0
        y: norms_sad_min)
      graph.append '<div style="position: absolute; top: ' + (o1.top - 17) + 'px; left: 30px; font-size: 9px;">min САД</div>'
      o2 = plot.pointOffset(
        x: 0
        y: norms_sad_max)
      graph.append '<div style="position: absolute; top: ' + (o2.top - 17) + 'px; left: 30px; font-size: 9px;">max САД</div>'
      o3 = plot.pointOffset(
        x: 0
        y: norms_dad_min)
      graph.append '<div class="nowrap" style="position: absolute; top: ' + (o3.top - 17) + 'px; right: 20px; font-size: 9px;">min ДАД</div>'
      o4 = plot.pointOffset(
        x: 0
        y: norms_dad_max)
      graph.append '<div class="nowrap" style="position: absolute; top: ' + (o4.top - 17) + 'px; right: 20px; font-size: 9px;">max ДАД</div>'
      o5 = p_plot.pointOffset(
        x: 0
        y: norms_pulse_min)
      pulse_graph.append '<div style="position: absolute; top: ' + (o5.top - 17) + 'px; left: 30px; font-size: 9px;">min ЧСС</div>'
      o6 = p_plot.pointOffset(
        x: 0
        y: norms_pulse_max)
      pulse_graph.append '<div style="position: absolute; top: ' + (o6.top - 17) + 'px; left: 30px; font-size: 9px;">max ЧСС</div>'

    else
      graph.hide()
      pulse_graph.hide()
  return
