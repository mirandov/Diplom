$ ->
  $tableSearch = $('.table-search')

  if $tableSearch.length

    $form1 = $('#programs-list-form')
    if $form1.length
      $table    = $('.table-search-table tbody')
      $template = $('#template_id')
      $type     = $('#type_id')
      $input    = $('.search-field')
      $clear    = $('#clear-filter')
      $result   = $('#number-of-items')

      pull      = $('<div/>')
      
      $table.find('tr').clone().appendTo pull
      $input.focus()
      pullRows = pull.find 'tr'
      $result.text $table.find('tr').length

      updateTable = () ->
        name        = $input.val().toLowerCase()
        t           = $template.val()
        templateId  = if t == '33' then ['32', '33'] else if t is '' then t else [t]
        typeId      = $type.val()
        result      = []
        $table.find('tr').remove()

        pullRows.each ->
          $row = $(@)
          trName = $row.find('.table-search-td-1').text().toLowerCase()
          trTemp = $row.attr 'template-id'
          trType = $row.attr 'type-id'


          if (trName.includes(name) or name is '') and 
             (trTemp in templateId or templateId is '') and 
             (typeId is trType or typeId is '')
            result.push @
            $row.click ->
              window.open $(@).data('link'), '_self', false
              return

        $table.append result
        $result.text $table.find('tr').length

      $template.change ->
        updateTable()

      $type.change ->
        updateTable()

      $input.bind 'keyup', (e) ->
        updateTable()

      $clear.click ->
        $table.find('tr').remove()
        $table.append pullRows
        $result.text $table.find('tr').length
        $template.val('')
        $type.val('')
        $input.val('').focus()
        false

      return 


    $form2 = $('#doctor-tasks-form')
    if $form2.length
      $table    = $('.table-search-table tbody')
      $taskType = $('#task_type_id')
      $result   = $('#number-of-items')
      $clear    = $('#clear-filter')

      byDate = true
      $sortByN  = $('#sort-by-name')
      $sortByD  = $('#sort-by-date')
      $sortByD.hide()

      pull      = $('<div/>')

      options = 
        valueNames: [ 'time', 'name' ]
        page: 600
      list = new List 'tasks-list', options

      sortTable = () ->
        if byDate
          list.sort 'time', { order: 'desc' }
        else
          list.sort 'name', { order: 'asc' }        

      $table.find('tr').clone().appendTo pull
      pullRows = pull.find 'tr'
      $result.text $table.find('tr').length

      updateTable = () ->
        typeId  = $taskType.val()
        result = []

        $table.find('tr').remove()

        pullRows.each ->
          $row = $(@)
          trType = $row.attr 'event-type'

          if typeId is trType or typeId is ''
            result.push @
            $row.click ->
              window.open $(@).data('link'), '_self', false
              return

        $table.append result
        $result.text $table.find('tr').length
        list = new List 'tasks-list', options
        sortTable()

      updateTable()

      $taskType.change ->
        updateTable()

      $clear.click ->
        $table.find('tr').remove()
        $table.append pullRows
        $result.text $table.find('tr').length
        $taskType.val('')

        $sortByN.show()
        $sortByD.hide()

        byDate = true
        list = new List 'tasks-list', options
        sortTable()

        false

      $sortByN.click ->
        byDate = false
        sortTable()
        $(@).hide()
        $sortByD.show()
        false

      $sortByD.click ->
        byDate = true
        sortTable()
        $(@).hide()
        $sortByN.show()
        false      

      return