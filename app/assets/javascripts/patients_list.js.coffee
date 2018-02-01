$ ->
  
  # use this -> render(file: 'legal_entities/index.json.jbuilder')
  # with 'legal_entities/index.json.jbuilder' and list of patients form @patients = ...


  $patientsList = $('#patients-list')

  if $patientsList.length

    minLength = 2

    host    = $(location).attr 'origin'
    $search = $('.search-field')
    $table  = $('table tbody')
    $status = $('.status .lead')
    loading = $('.loading')
    statusLoading = loading.find('.status-loading')

    btn = $('#show-all-patients')
    btnContainer = $('.show-all-patients')

    opts =
      lines: 9
      length: 8
      width: 3
      radius: 6
      color: '#333'
      opacity: 0.20
      speed: 1
      trail: 60
      shadow: false
      position: 'relative'

    link = host + '/cabinets/patients_list.json'

    patients = []

    do ->
      $.getJSON link, (data) ->
        if data
          formatted = _.map data, (p) ->
            program = false
            if p.length > 1
              program =
                name:     p[1].name
                measurement: p[1].measurement
                date:     p[1].date
            patient =
              id:         p[0].id
              surname:    p[0].surname
              firstname:  p[0].name
              patronymic: p[0].patronymic
              name:       p[0].surname.toLowerCase() + ' ' + p[0].name.toLowerCase() + ' ' + p[0].patronymic.toLowerCase()
              program: program
          patients = formatted
        else
          setStatus 6
          []

    capitalizeFirst = (s) ->
      s.charAt(0).toUpperCase() + s.slice(1)

    ending = (n) ->
      patient =
        name: 'пациент'
        one: ''
        few: 'а'
        many: 'ов'
      e = ''
      if n > 10 && n < 20
        e = 'many'
      else
        n = n % 10
        e = if n == 1 then 'one' else if n < 5 and n > 1 then 'few' else 'many'
      return patient.name + patient[e]

    setStatus = (id, value) ->
      text = 'Статус не найден'
      statusLoading.spin false
      switch id
        when 0
          text = 'Начните вводить ФИО пациента'
          btnContainer.show()
        when 1
          text = 'Пациент "' + value + '" не найден'
          btnContainer.show()
        when 2
          text = 'Надено: ' + value + ' ' + ending value
        when 4
          text = 'Поиск пациентов...'
          statusLoading.spin opts
        when 5
          text = 'Вы ввели: "' + value + '"' 
      $status.text text

    drawTable = (data) ->
      console.log data
      l = data.length
      if l
        setStatus 2, l

        sorted = _.sortBy data, 'name'

        _.each sorted, (p) ->

          patient = p
          program = p.program
          programName = measurement = date = ''
          if program
            programName = program.name
            measurement = program.measurement
            date = program.date
          $table.append """
            <tr class="tr-href" data-link="/people/#{patient.id}">
              <td>
                <div class="big inline surname-formatted">
                  #{patient.surname}
                </div>
                <div class="inline">
                  #{patient.firstname} #{patient.patronymic}
                </div>
              </td>
              <td class="hidden-xs">
                <ul>
                  <li>
                    #{programName}
                  </li>
                </ul>
              </td>
              <td class="hidden-xs">
                <ul>
                  <li class="big">
                    #{measurement}
                  </li>
                  <li>
                    #{date}
                  </li>
                </ul>
              </td>
            </tr>
          """

        tds = $('.tr-href').find('td').click ->
          window.location = $(this).parent('tr').data('link')
          return
      else
        setStatus 1, $search.val().trim()

    search = (val) ->
      matches = []
      matches = _.filter patients, (patient) ->
        patient.name.includes val
      drawTable matches

    getValue = (s) ->
      $table.children().remove()
      value = s.val().trim().toLowerCase()
      if value.length
        setStatus 5, value
        if value.length >= minLength
          search value
      else
        setStatus 0

    # action listener
    $search.bind 'keydown keyup change', (e) ->
      $this = $(this)

      if e.type == 'keyup'
        getValue $this

        if e.keyCode == 13
          $this.blur()

    btn.click ->
      setStatus 4
      btnContainer.hide()
      check = () ->
        setTimeout (->
          if patients.length
            return drawTable patients
          else
            check()
        ), 500
      check()
      false

    setStatus 0
    $search.focus()

    # check if data still there
    if $search.val().length
      setStatus 4
      setTimeout (->
        return getValue($search)
      ), 1000

    return