$ ->

  # ticking machine for task list
  
  param = '_self'
  t = 0

  $wsTable = $('.ticking-table')
  if $wsTable.length
    table = $('#tasks-table')

    window.timer_id ||= setInterval( ->

      if (t < 10)
        unless $('#tasks-table').length
          clearInterval(window.timer_id)
          window.timer_id = 0
        console.log 'tick...'
        t++

        options = valueNames: [ 'time' ]
        
        historyList = new List 'tasks-list', options
        historyList.sort 'time', { order: 'desc' }

        $('.tr-href').each ->
          $this = $(this)
          owner = $this.find('.owner')
          time = $this.find('.time-elapsed')

          $this.click ->
            window.open $(this).data('link'), param, false
            return

          if owner.data('owner') > 0
            owner.removeClass 'hidden'

          time.html(window.timeAgo(time.data('sec')))
          return

        if table.hasClass 'hidden'
          table.removeClass 'hidden'

        return
      else
        t = 0
        if ($('#tasks-table .tr-href').length == 0)
          $('#tasks-absent').removeClass 'hidden'
        return

    , 1000)

    return