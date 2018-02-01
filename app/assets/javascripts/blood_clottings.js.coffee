# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  graph = $("#bClotting_graph")

  if graph.length

    tableData  = $('#meterage_table td.time')
    dataLength = tableData.length

    if dataLength
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
          labelFormatter: null
          noColumns: 2
          show: true
        xaxis:
          # mode: "time"
          # timeformat: "%d.%m"
          ticks: []
          timezone: "Europe/Moscow"
          autoscaleMargin: 0.01
          tickColor: "#DDD" # vertical grid ticks color
          minTickSize: [
            1
            'day'
          ]
        grid:
          hoverable: true
          autoHighlight: true
          borderWidth: 0
          mouseActiveRadius: 60

      # Store values for flot here:
      plotData = []

      multiplicity = if dataLength < 20 then 1 else ~~(dataLength / 10)

      currentPage = parseInt($('ul.pagination li.active:first').text()) || 1
      perPage = 15 # TODO: fix

      label_format = (i, $obj)->
        timestamp = $obj.html()

        if x = timestamp.search(/\d/) && !((i - 1) % multiplicity)
          timestamp = timestamp.substr(x, timestamp.indexOf(',') - x)
          return "#{((currentPage - 1) * perPage) + i + 1} день<br>#{timestamp}" # "length - i" because sort is DESC

        return false

      tableData.each (i) ->
        t = $(this)
        # time must be an UTC!
        plotData.push([i, parseFloat(t.next().text()), t.data('time')])
        label = label_format(i, t)
        options.xaxis.ticks.push([i, label]) if label

      plot = $.plot(
        graph

        [
          data: plotData
          color: "#383838"
          cColor: "#262626"
        ]
        
        options)

      # # Формат отображения содержимого подсказки (при наведении мыши):
      # # значение + дата и время (на следующей строке).
      # formatter = (data) ->
      #   timestamp = tableData.filter(":eq(#{data[0]})").text()
      #   "<div class='text-center'>#{data[1].toFixed(2)}</div>#{timestamp}"

      # graph.set_tooltip({pos_y: -5}, formatter)
    else
      graph.hide()

  # Form helpers
  do ->
    low_select        = $('#low_alco_select')
    hard_select       = $('#hard_alco_select')
    alco_selects      = low_select.add hard_select
    alco_amount_input = $('#meterage_blood_clotting_alco_amount')
    input_div         = alco_amount_input.parent().parent()

    alco_selects.hide().removeClass('hide').change ()->
      alco_amount_input.val($(this).val())

    $('#meterage_blood_clotting_alcohol').change ()->
      switch $(this).val()
        when '1' # low alcohol  TODO: use BloodClotting::ALCO_TYPES
          hard_select.hide()
          low_select.change().show()
          input_div.slideDown(200) if input_div.is(":hidden")
          alco_amount_input.parent().parent()
        when '2' # hard alcohol TODO: use BloodClotting::ALCO_TYPES
          low_select.hide()
          hard_select.change().show()
          input_div.slideDown(200) if input_div.is(":hidden")
        else     # no alcohol
          alco_amount_input.val('')
          alco_selects.hide()
          input_div.slideUp(200)
      return
    .change()

    return

  return
