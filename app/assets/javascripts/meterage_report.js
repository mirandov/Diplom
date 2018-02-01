$(function () {

  var sixHours, sixHoursArray, d_data, data_length, graph, graph_options, p_data, pulse_graph, s_data, table_data, table_data_row, table_header, plot, pulse_plot, graphSAD, graphDAD, graphPulse, plotSAD, plotDAD, plotPulse,
      norms_sad_min, norms_sad_max, norms_dad_min, norms_dad_max, norms_pulse_min, norms_pulse_max;

  function drawBackgroundHook(plot, canvascontext) { 
    var canvas = plot.getCanvas();
    canvascontext.fillStyle = '#FFFFFF';
    canvascontext.fillRect(0, 0, canvas.width, canvas.height);
  };
 
  function makeBaseGraphOptions(yMin, yMax, yTicks, gridMarkings) {
    var options = {
      series: {
        lines: {
          show: true,
          lineWidth: 2,
        },
        points: {
          show: true,
          radius: 4,
          lineWidth: 2
        },
        shadowSize: 3,
        highlightColor: null
      },
      legend: {
        show: true,
        noColumns: 2,
        labelFormatter: null,
      },
      yaxis: {
        min: yMin,
        max: yMax,
        ticks: yTicks
      },
      xaxis: {
        mode: "time",
        timeformat: "%d.%m",
        timezone: "browser",
        autoscaleMargin: 0.01,
        tickColor: "#DDD", // vertical grid ticks color
        // tickLength: 5,     // vertical grid ticks
        minTickSize: [1, 'day']
      },
      grid: {
        backgroundColor: { colors: [ "#FFF", "#FFF" ] },
        hoverable: true,
        autoHighlight: true,
        markings: gridMarkings,
        borderWidth: 0,
        mouseActiveRadius: 60,
      },
      canvas: true
    };
    return options;
  }
  
  // limits of Pressure Graphs
  function makePressureGraphOptions() {
    return makeBaseGraphOptions(20, 200, 10,
      [ 
        { 
          yaxis: { from: norms_dad_min, to: norms_dad_min }, 
          color: "#BABABA" 
        }, { 
          yaxis: { from: norms_dad_max, to: norms_dad_max }, 
          color: "#BABABA" 
        },
        { 
          yaxis: { from: norms_sad_min, to: norms_sad_min }, 
          color: "#383838"
        }, { 
          yaxis: { from: norms_sad_max, to: norms_sad_max }, 
          color: "#383838"
        }
      ]
    );
  }

  // limit of Pulse Graph
  function makePulseGraphOptions() {
    return makeBaseGraphOptions(40, 120, 8,
      [ 
        { 
          yaxis: { from: norms_pulse_min, to: norms_pulse_min }, 
          color: "#858585" 
        },
        { 
          yaxis: { from: norms_pulse_max, to: norms_pulse_max }, 
          color: "#858585" 
        }
      ]
    );
  }

  function makeSeriesData(dataArray, title, lineColor, fontColor) {
    var i;
    var labelsArray = [];

    for(i = 0; i < dataArray.length; i++)
      labelsArray.push( dataArray[i][1] );
    
    var seriesData =
    {
      data: dataArray,
      labels: labelsArray, 
      label: title,
      canvasRender: true,
      showLabels: true, 
      labelPlacement: "above", 
      color: lineColor,
      cColor: fontColor,
      cFont: "12px Arial",
      cPadding: 4
    }
    return seriesData;
  }
  
  graph = $("#report__blood_press_graph");
  pulse_graph = $("#report__pulse_graph");
  
  if (graph.length) {
    table_data = $('#report__meterage_table');

    if (table_data.length) {
      table_data = table_data.find('td.time')
      s_data = [];
      d_data = [];
      p_data = [];
      
      table_data.each(function() {
        var $this, dbp, pulse, sbp, time, date;

        $this = $(this);
        time = parseInt($this.data('time'));
        sbp = $this.next();
        dbp = sbp.next();
        pulse = dbp.next();

        s_data.push([time, parseInt(sbp.text())]);
        d_data.push([time, parseInt(dbp.text())]);
        p_data.push([time, parseInt(pulse.text())]);
        
        return true;
      });

      var start_time = s_data[0][0];
      var end_time = s_data[s_data.length - 1][0];

      var norms = $('#report__meterage_table th');
      norms_sad_min = norms[1].getAttribute('data-min');
      norms_sad_max = norms[1].getAttribute('data-max');
      norms_dad_min = norms[2].getAttribute('data-min');
      norms_dad_max = norms[2].getAttribute('data-max');
      norms_pulse_min = norms[3].getAttribute('data-min');
      norms_pulse_max = norms[3].getAttribute('data-max');
    
      table_header = $("#report__meterage_table thead tr:first th");

      plot = $.plot(
        graph, 
        [
          makeSeriesData(s_data, table_header.filter(":eq(1)").text(), "#383838", "#262626"),
          makeSeriesData(d_data, table_header.filter(":eq(2)").text(), "#787878", "#5C5C5C")
        ], 
        makePressureGraphOptions()
      );

      if (pulse_graph.length) {
        pulse_plot = $.plot(
          pulse_graph, 
          [
            makeSeriesData(p_data, table_header.filter(":eq(3)").text(), "#343434", "#2B2B2B")
          ], 
          makePulseGraphOptions() 
        );
      }

      var o1,
          o2,
          o3,
          o4,
          o5,
          o6;

      o1 = plot.pointOffset({ x: 0, y: norms_sad_min });
      graph.append('<div style="position: absolute; top: ' + (o1.top - 17) + 'px; left: 30px; font-size: 8px;">min САД</div>');

      o2 = plot.pointOffset({ x: 0, y: norms_sad_max });
      graph.append('<div style="position: absolute; top: ' + (o2.top - 17) + 'px; left: 30px; font-size: 8px;">max САД</div>');
     
      o3 = plot.pointOffset({ x: 0, y: norms_dad_min });
      graph.append('<div class="nowrap" style="position: absolute; top: ' + (o3.top - 17) + 'px; right: 20px; font-size: 8px;">min ДАД</div>');

      o4 = plot.pointOffset({ x: 0, y: norms_dad_max });
      graph.append('<div class="nowrap" style="position: absolute; top: ' + (o4.top - 17) + 'px; right: 20px; font-size: 8px;">max ДАД</div>');

      o5 = pulse_plot.pointOffset({ x: 0, y: norms_pulse_min });
      pulse_graph.append('<div style="position: absolute; top: ' + (o5.top - 17) + 'px; left: 30px; font-size: 8px;">min ЧСС</div>');

      o6 = pulse_plot.pointOffset({ x: 0, y: norms_pulse_max });
      pulse_graph.append('<div style="position: absolute; top: ' + (o6.top - 17) + 'px; left: 30px; font-size: 8px;">max ЧСС</div>');
    }
  }

  var formatDateTime = function(time) {
    var months = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря'
    ];
    
    var date = new Date();
    date.setTime(time);
    
    var hours = date.getHours() < 10 ? '0' + date.getHours() : date.getHours();
    var minutes = date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes();
    
    return date.getDate() + ' ' + months[date.getMonth()] + ' ' + date.getFullYear() + ', ' + hours + ':' + minutes;
  }
  
  $("#time-interval-apply").click(
    function() {

      var makeCell = function(value, min, max) {
        if( value < min || value > max )
          return '<td><span class="strong">' + value + '</span></td>';
        else
          return '<td>' + value + '</td>';
      }
    
      var showData = function (sData, dData, pData) {
        plot.setData(
          [
            makeSeriesData(sData, table_header.filter(":eq(1)").text(), "#383838", "#262626"),
            makeSeriesData(dData, table_header.filter(":eq(2)").text(), "#787878", "#5C5C5C")
          ]
        );
        plot.setupGrid();
        plot.draw();

        pulse_plot.setData(
          [
            makeSeriesData(pData, table_header.filter(":eq(3)").text(), "#343434", "#2B2B2B")
          ]
        );
        pulse_plot.setupGrid();
        pulse_plot.draw();
        
        var i;
        var tableContent = "";
        
        for( i = 0; i < sData.length; i++ ) {
          var time, formattedTime, s, d, p;
          
          time = sData[i][0];
          formattedTime = formatDateTime(time);

          s = sData[i][1];
          d = dData[i][1];
          p = pData[i][1];
          
          tableContent += 
            '<tr>' +
            '<td class="time" data-time="' + time + '">' + formattedTime + '</td>' +
            makeCell(s, norms_sad_min, norms_sad_max) +
            makeCell(d, norms_dad_min, norms_dad_max) +
            makeCell(p, norms_pulse_min, norms_pulse_max) +
            '</tr>';
        }
        $("#report__meterage_table tbody").html(tableContent);
      }

      var interval = $("#time-interval").val();
      
      if( !$.isNumeric(interval) || interval < 0 ) {
        showData(s_data, d_data, p_data);
        return false;
      }

      var cur_date_time_start = s_data[0][0];
      var cur_date_time_stop = cur_date_time_start + interval * 60 * 1000;
      
      var new_s_data = [];
      var new_d_data = [];
      var new_p_data = [];
      
      var accum_s = 0;
      var accum_d = 0;
      var accum_p = 0;
      var accum_count = 0;
      
      var i;

      var tryToAddData = function() {
        if(accum_count > 0) {
          accum_s /= accum_count;
          accum_d /= accum_count;
          accum_p /= accum_count;

          accum_s = parseInt(accum_s);
          accum_d = parseInt(accum_d);
          accum_p = parseInt(accum_p);
          
          new_s_data.push([cur_date_time_start, accum_s]);
          new_d_data.push([cur_date_time_start, accum_d]);
          new_p_data.push([cur_date_time_start, accum_p]);
        }
      }

      for( i = 0; i < s_data.length; i++ ) {
        if( s_data[i][0] >= cur_date_time_start && s_data[i][0] <= cur_date_time_stop ) {
          accum_s += s_data[i][1];
          accum_d += d_data[i][1];
          accum_p += p_data[i][1];
          accum_count++;
        }
        else {
          tryToAddData();

          cur_date_time_start = s_data[i][0];
          cur_date_time_stop = cur_date_time_start + interval * 60 * 1000;
          
          accum_s = s_data[i][1];
          accum_d = d_data[i][1];
          accum_p = p_data[i][1];
          accum_count = 1;
        }
      }
      tryToAddData();

      showData(new_s_data, new_d_data, new_p_data);

      return false;
    }
  );
});
