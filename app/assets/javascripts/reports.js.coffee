# Place here all the behaviors and hooks related to the application as a whole.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  # Using datepicker local

  reports = $('.admin-reports')
  host = $(location).attr 'origin'

  $flashBlock  = $('.flash-block')

  flash = (text) ->
    name = 'flash-' + new Date().getTime()
    $flashBlock.prepend(
      """
        <div class="#{name} alert alert-dismissible alert-alert text-left fade in">
          <button class="close" type="button" data-dismiss="alert">
            <span aria-hidden="true">&times;</span>
          </button>
          #{text}
        </div>
      """
    )
    setTimeout (->
      $flashBlock.find(".#{name}").remove()
      return
    ), 5000

  if reports.length
    first   = $('#report-1')
    second  = $('#report-2')
    fourth  = $('#report-4')
    fifth   = $('#report-5')
    firstCommercial = $('#commercial-report-1')
    dataExport      = $('#data-export')
    newDataExport   = $('#new-data-export') 

    updateButtonText = (val) ->
      (options, select) ->
        l = if options.length == select.find('option').length then 'все' else options.length
        output = if l then ' (' + l + ')' else ''
        val + output

    selectOptions = (val, selectAll = false) ->
      if selectAll
        maxHeight: 272
        buttonText: updateButtonText(val)
        includeSelectAllOption: true
        enableFiltering: true
        filterPlaceholder: 'Поиск'
        enableCaseInsensitiveFiltering: true
        selectAllText: 'Все ' + val
      else
        maxHeight: 272
        buttonText: updateButtonText(val)

    if firstCommercial.length
      $legalEntity  = $('#warehouse')
      $complectType = $('#complect_type')
      $doctor       = $('#doctor')
      $region       = $('#region')
      $subject      = $('#subject')
      $doctorOpts   = $('#doctor option')
      $table        = $('#commercial-report-1-table')
      $tbody        = $table.find('tbody')
      $form         = $('#commercial-report-1-form')

      sortBy = (x) ->
        $('.tr-loading').remove()

        options = {
          valueNames: [
            'id'
          ]
        }
        complectTypes = new List 'commercial-report-1-table-containter', options
        complectTypes.sort x, { order: 'asc' }

      makeTableRow = (k, v, d) ->
        """
          <tr class="complect-type-#{v} warning">
            <td class="hidden id">#{k}00</td>
            <td>#{d.name}</td>
            <td>#{d.complects_quantity}</td>
            <td>#{d.complects_idled}</td>
            <td>#{d.complects_idled_m}</td>
            <td>#{d.complects_in_use}</td>
          </tr>
        """

      $complectType.multiselect selectOptions 'Комплекты', true
      $region.multiselect       selectOptions 'Округа', true
      $subject.multiselect      selectOptions 'Субъекты', true
      $legalEntity.multiselect  selectOptions 'Организации', true
      $doctor.multiselect       selectOptions 'Врачи', false

      $('select[multiple="multiple"]').change ->
        values = $(this).val() || ['0']
        link = host + '/reports/filter?type=' + $(this).prop('id') + '&values=' + values.join(',')

        $.getJSON link, (data) ->
          if data.subjects != undefined
            $subject.find('option').prop('disabled', true).prop('selected', false)
            if data.subjects.length
              data.subjects.forEach (x) -> 
                $option = $subject.find('option[value="' + x + '"]')
                if $option.length
                  $option.prop('disabled', false)
            $subject.multiselect 'refresh'

          if data.warehouses != undefined
            $legalEntity.find('option').prop('disabled', true).prop('selected', false)
            if data.warehouses.length
              data.warehouses.forEach (x) -> 
                $option = $legalEntity.find('option[value="' + x + '"]')
                if $option.length
                  $option.prop('disabled', false)
            $legalEntity.multiselect 'refresh'

          if data.doctors != undefined
            $doctor.find('option').prop('disabled', true).prop('selected', false)
            if data.doctors.length
              data.doctors.forEach (x) -> 
                $option = $doctor.find('option[value="' + x + '"]')
                if $option.length
                  $option.prop('disabled', false)
            $doctor.multiselect 'refresh'

        # doctorIds = []
        # legalEntityIds = $('#warehouse_id').val()
        # i = 0
        # $.each legalEntityIds, (key, val) ->
        #   link = host + '/reports/search?inquiry=3&warehouse=' + val
        #   $.getJSON link, (data) ->
        #     if data
        #       doctorIds = _.uniq doctorIds.concat data.doctorIds
        #       i++

        #       if i == legalEntityIds.length
        #         newOpts = []
        #         $.each doctorIds, (i, v) ->
        #           $doctorOpts.each ->
        #             if parseInt($(this).val()) == v
        #               newOpts.push this
        #         $('#doctor_id option').remove()
        #         $('#doctor_id').append newOpts
        #         $('#doctor_id').multiselect 'rebuild'

      $form.submit ->

        $submit = $(this).find ':submit'
        $submit.attr 'disabled', true

        # session is to prevent dublicating rows
        session = 'session-' + moment().unix()

        $tbody.removeClass().addClass('list').addClass session
        $table.hide()
        $tbody.children('tr').remove()

        complectTypeIds = $('#complect_type').val()
        legalEntityIds = $('#warehouse').val()

        if legalEntityIds == null
          legalEntityIds = []
          $('#warehouse option').map(->
            legalEntityIds.push $(this).val()
          )

        t = 0

        if complectTypeIds != null
          $table.find('.'+session).append """<tr class="tr-loading text-center"><td colspan="6">Загрузка...</td></tr>"""

          total = (complectTypeIds.length) * (legalEntityIds.length) + complectTypeIds.length

          $.each complectTypeIds, (key1, val1) ->
            link1 = host + '/reports/search?report=1c&inquiry=1&complect_type=' + val1 + '&warehouse=' + legalEntityIds

            console.log link1
            console.log legalEntityIds

            $.getJSON link1, (data1) ->
              if data1
                $tr1 = makeTableRow key1, val1, data1
                t++

                $table.find('.'+session).append $tr1

                if legalEntityIds != null
                  $.each legalEntityIds, (key2, val2) ->
                    link2 = host + '/reports/search?report=1c&inquiry=2&complect_type=' + val1 + '&warehouse=' + val2
                    
                    $.getJSON link2, (data2) ->
                      if data2
                        $tr2 = """
                          <tr class="complect-type-#{val1}-#{val2} info">
                            <td class="hidden id">#{key1}#{key2}0</td>
                            <td><div class="small">#{data2.name}</div></td>
                            <td>#{data2.complects_quantity}</td>
                            <td>#{data2.complects_idled}</td>
                            <td>#{data2.complects_idled_m}</td>
                            <td>#{data2.complects_in_use}</td>
                          </tr>
                        """
                        t++

                        $('.pull-for-trs').append $tr2
                        $(".complect-type-#{val1}-#{val2}").insertAfter $table.find('.'+session).find('.complect-type-'+val1)

                        if t == total
                          sortBy 'id'

                        doctorIds = $('#doctor_id').val()

                        if doctorIds == null
                          link2Doctors = host + '/reports/search?report=1c&inquiry=3&warehouse=' + val2
                          $.getJSON link2Doctors, (doctorsList) ->
                            if doctorsList
                              $.each doctorsList.doctorIds, (key3, val3) ->
                                link3 = host + '/reports/search?report=1c&inquiry=4&complect_type=' + val1 + '&warehouse=' + val2 + '&doctor=' + val3
                                $.getJSON link3, (data3) ->
                                  if data3
                                    $tr3 = """
                                      <tr class="complect-type-#{val1}-#{val2}-#{val3}">
                                        <td class="hidden id">#{key1}#{key2}#{key3}</td>
                                        <td><div class="small">#{data3.name}</div></td>
                                        <td>#{data3.complects_quantity}</td>
                                        <td>#{data3.complects_idled}</td>
                                        <td>#{data3.complects_idled_m}</td>
                                        <td>#{data3.complects_in_use}</td>
                                      </tr>
                                    """

                                    $('.pull-for-trs').append $tr3
                                    $(".complect-type-#{val1}-#{val2}-#{val3}").insertAfter $table.find('.'+session).find(".complect-type-#{val1}-#{val2}")

                        else
                          $.each doctorIds, (key3, val3) ->
                            link3 = host + '/reports/search?report=1c&inquiry=4&complect_type=' + val1 + '&warehouse=' + val2 + '&doctor=' + val3
                            $.getJSON link3, (data3) ->
                              if data3
                                $tr3 = """
                                  <tr class="complect-type-#{val1}-#{val2}-#{val3}">
                                    <td class="hidden id">#{key1}#{key2}#{key3}</td>
                                    <td><div class="small">#{data3.name}</div></td>
                                    <td>#{data3.complects_quantity}</td>
                                    <td>#{data3.complects_idled}</td>
                                    <td>#{data3.complects_idled_m}</td>
                                    <td>#{data3.complects_in_use}</td>
                                  </tr>
                                """

                                $('.pull-for-trs').append $tr3
                                $(".complect-type-#{val1}-#{val2}-#{val3}").insertAfter $table.find('.'+session).find(".complect-type-#{val1}-#{val2}")


          $table.show()
        
        else
          $table.show()

        $submit.attr 'disabled', false
        false 

    if fourth.length
      # $('.th-popover').popover
      #   placement: 'top'
      #   trigger: 'hover'
      $('.th-popover').click ->
        alert $(this).attr 'data-content'
        false

      $beginDate = $('#fourth_report_begin_date')
      $endDate = $('#fourth_report_end_date')
      $period = $('#fourth_report_period')

      $template = $('#template')
      $region = $('#region')
      $subject = $('#subject')
      $medOrganization = $('#med_organization')
      $position = $('#position')
      $doctor = $('#doctor')
      $patient = $('#patient')
      $form = $('form')
      $table = $('table')
      $tbody = $table.find('tbody')

      $sortBtn = $('#sort-btn')

      $template.find('option[value=33]').prop 'selected', true

      $template.multiselect         selectOptions 'Нозологии', true
      $region.multiselect           selectOptions 'Округа', true
      $subject.multiselect          selectOptions 'Субъекты', true
      $medOrganization.multiselect  selectOptions 'Медицинские организации', true
      $position.multiselect         selectOptions 'Должности', true
      $doctor.multiselect           selectOptions 'Врачи' , true
      $patient.multiselect          selectOptions 'Пациенты', true

      sort = () ->
        $('.tr-loading').remove()

        options = {
          page: 1000
          valueNames: [
            'id'
          ]
        }

        complectTypes = new List 'fourth-report-table-container', options
        complectTypes.sort 'id', { order: 'asc' }

      $sortBtn.click ->
        sort()
        false

      pad = (num) ->
        s = '00' + num
        s.substr(s.length - 2)

      makeTableRow = (id, data, value, className, title, additional = {}) ->

        anchor = """
          <a href="#{link}" target="_blank">#{data.title}</a>
        """

        makeTitleDiv = (obj) ->
          if Object.keys(obj).length == 0
            return data.title
          else
            return """
              <a href="#{obj.link}" target="_blank">#{data.title}</a>
            """

        makeProgramDiv = (obj) ->
          if Object.keys(obj).length > 0 && obj.medProgram.length == 1
            return """
              <a href="#{host + '/med_programs/' + obj.medProgram[0]}" target="_blank">#{data.data.c2}</a>
            """          
          else
            return data.data.c2

        titleContainer = makeTitleDiv(additional)

        programSizeContainer = makeProgramDiv(additional)

        """
          <tr class="row-#{id} #{className}" data-value="#{value}">
            <td class="hidden id">#{id}</td>
            <td>
              <div class="small">#{title}</div>
            </td>
            <td>
              <div class="small">#{titleContainer}</div>
            </td>
            <td>#{programSizeContainer}</td>
            <td>#{data.data.c3}</td>
            <td>#{data.data.c4}%</td>
            <td>#{data.data.c5}</td>
            <td>#{data.data.c6}%</td>
            <td>#{data.data.c7}</td>
            <td>#{data.data.c8}%</td>
            <td>#{data.data.c9}</td>
            <td>#{data.data.c10}%</td>
            <td>#{data.data.c11}</td>
            <td>#{data.data.c12}%</td>
            <td>#{data.data.c13}</td>
            <td>#{data.data.c14}%</td>
            <td>#{data.data.c15}</td>
            <td>#{data.data.c16}%</td>
            <td>#{data.data.c17}</td>
            <td>#{data.data.c18}%</td>
          </tr>
        """

      updateSelect = (el, data) ->
        if data != undefined
          el.find('option').prop('disabled', true)
          data.forEach (x) ->
            $option = el.find('option[value="' + x + '"]')
            if $option.length
              $option.prop('disabled', false)
          el.multiselect 'refresh'

      $('select[multiple="multiple"]').change ->
        values = $(this).val() || ['0']
        link = host + '/reports/filter?type=' + $(this).prop('id') + '&values=' + values.join(',')

        $.getJSON link, (data) ->
          if data.regions != undefined
            $region.find('option').prop('disabled', true).prop('selected', false)
            if data.regions.length
              data.regions.forEach (x) -> 
                $option = $region.find('option[value="' + x + '"]')
                if $option.length
                  $option.prop('disabled', false)
            $region.multiselect 'refresh'

          if data.subjects != undefined
            $subject.find('option').prop('disabled', true).prop('selected', false)
            if data.subjects.length
              data.subjects.forEach (x) ->
                $option = $subject.find('option[value="' + x + '"]')
                if $option.length
                  $option.prop('disabled', false)
            $subject.multiselect 'refresh'

          if data.organizations != undefined
            $medOrganization.find('option').prop('disabled', true).prop('selected', false)
            if data.organizations.length
              data.organizations.forEach (x) ->
                $option = $medOrganization.find('option[value="' + x + '"]')
                if $option.length
                  $option.prop('disabled', false)
            $medOrganization.multiselect 'refresh'

          if data.positions != undefined
            $position.find('option').prop('disabled', true).prop('selected', false)
            if data.positions.length
              data.positions.forEach (x) ->
                $option = $position.find('option[value="' + x + '"]')
                if $option.length
                  $option.prop('disabled', false)
            $position.multiselect 'refresh'

          if data.doctors != undefined
            $doctor.find('option').prop('disabled', true).prop('selected', false)
            if data.doctors.length
              data.doctors.forEach (x) ->
                $option = $doctor.find('option[value="' + x + '"]')
                if $option.length
                  $option.prop('disabled', false)
            $doctor.multiselect 'refresh'


      $form.submit ->
        beginDate = moment($beginDate.val(), 'DD.MM.YYYY')
        endDate = moment($endDate.val(), 'DD.MM.YYYY')
        chosenPeriod = $period.val()
        devider = (->
          switch chosenPeriod
            when 'week'
              return [1, 'week', 'неделя']
            when 'month'
              return [1, 'month', 'месяц']
            when 'quarter'
              return [3, 'months', 'квартал']
            when 'half_year'
              return [6, 'months', 'полгода']
            when 'year'
              return [1, 'year', 'год']
            else
              return [1, 'whole']
        )()

        periods = []

        session = 'session-' + moment().unix()

        templatesChosen = $template.val() || [33]
        medOrganizationsChosen = $medOrganization.val() || []
        regionsChosen = $region.val() || []
        subjectsChosen = $subject.val() || []
        positionsChosen = $position.val() || []
        doctorsChosen = $doctor.val() || []
        patientsChosen = $patient.val() || []

        t = 0

        $tbody.removeClass().addClass('list').addClass session
        $table.hide()
        $tbody.children('tr').remove()

        if endDate.unix() - beginDate.unix() < 0
          flash 'Дата начала периода не должна быть позже даты окончания'
          $beginDate.val ''
          $endDate.val ''
          false

        if devider[1] == 'whole'
          diff = 1
        else
          diff = moment(endDate).add(1, 'day').diff(beginDate, devider[1], true)

        total = Math.ceil(diff / devider[0])
        i = 0

        while i < total
          periodBegin = ''
          periodEnd = ''
          if periods.length == 0
            periodBegin = beginDate
          else
            periodBegin = moment(periods[periods.length - 1][1], 'DD.MM.YYYY').add(1, 'day')

          if i == total - 1
            periodEnd = endDate
          else
            periodEnd = moment(periodBegin).add(devider[0], devider[1]).subtract(1, 'day')

          periods.push [moment(periodBegin).format('DD.MM.YYYY'), moment(periodEnd).format('DD.MM.YYYY')]
          i++ 

        $table.find('.'+session).append """<tr class="tr-loading text-center"><td colspan="18">Загрузка...</td></tr>"""

        $.each periods, (index1, value1) ->
          i1 = index1 + 1
          pi1 = pad i1
          currentPeriod = if devider[1] == 'whole' then "Весь%20период" else "#{i1}%20#{devider[2]}"
          link1 = host + '/reports/search?report=4&inquiry=1&period_start=' + value1[0] + '&period_end=' + value1[1] + '&value=' + currentPeriod + '&templates=' + templatesChosen.join(',') + '&organizations=' + medOrganizationsChosen.join(',') + '&regions=' + regionsChosen.join(',') + '&subjects=' + subjectsChosen.join(',') + '&positions=' + positionsChosen.join(',') + '&doctors=' + doctorsChosen.join(',')

          $.getJSON link1, (data1) ->
            if data1
              $tr1 = makeTableRow "#{pi1}00000000000000", data1, i1, 'depth-1', 'Период'

              $table.find('.' + session).append $tr1

              medPrograms = data1.ids.med_programs
              templates = if templatesChosen.length then templatesChosen else data1.ids.children

              t++

              if t == periods.length
                sort()

              if data1.ids.children.length
                $.each templates, (index2, value2) ->
                  i2 = index2 + 1
                  pi2 = pad i2
                  link2 = host + '/reports/search?report=4&inquiry=2&ids=' + medPrograms + '&value=' + value2
                  
                  $.getJSON link2, (data2) ->
                    if data2
                      $tr2 = makeTableRow "#{pi1}#{pi2}000000000000", data2, value2, 'depth-2', 'Нозология'

                      $('.pull-for-trs').append $tr2
                      $(".row-#{pi1}#{pi2}000000000000").insertAfter $table.find('.'+session).find(".row-#{pi1}00000000000000")
                      
                      medPrograms = data2.ids.med_programs
                      regions = if regionsChosen.length then regionsChosen else data2.ids.children

                      t++

                      if regions.length
                        $.each regions, (index3, value3) ->
                          i3 = index3 + 1
                          pi3 = pad i3
                          link3 = host + '/reports/search?report=4&inquiry=3&ids=' + medPrograms + '&value=' + value3
                          
                          $.getJSON link3, (data3) ->
                            if data3
                              $tr3 = makeTableRow "#{pi1}#{pi2}#{pi3}0000000000", data3, value3, 'depth-3', 'Округ'

                              $('.pull-for-trs').append $tr3
                              $(".row-#{pi1}#{pi2}#{pi3}0000000000").insertAfter $table.find('.'+session).find(".row-#{pi1}#{pi2}000000000000")
                              
                              medPrograms = data3.ids.med_programs
                              subjects = if subjectsChosen.length then subjectsChosen else data3.ids.children

                              t++

                              if subjects.length
                                $.each subjects, (index4, value4) ->
                                  i4 = index4 + 1
                                  pi4 = pad i4
                                  link4 = host + '/reports/search?report=4&inquiry=4&ids=' + medPrograms + '&value=' + value4
                                  
                                  $.getJSON link4, (data4) ->
                                    if data4
                                      $tr4 = makeTableRow "#{pi1}#{pi2}#{pi3}#{pi4}00000000", data4, value4, 'depth-4', 'Субъект'

                                      $('.pull-for-trs').append $tr4
                                      $(".row-#{pi1}#{pi2}#{pi3}#{pi4}00000000").insertAfter $table.find('.'+session).find(".row-#{pi1}#{pi2}#{pi3}0000000000")
                                      
                                      medPrograms = data4.ids.med_programs
                                      medOrganizations = if medOrganizationsChosen.length then medOrganizationsChosen else data4.ids.children

                                      t++

                                      if medOrganizations.length
                                        $.each medOrganizations, (index5, value5) ->
                                          i5 = index5 + 1
                                          pi5 = pad i5
                                          link5 = host + '/reports/search?report=4&inquiry=5&ids=' + medPrograms + '&value=' + value5
                                          
                                          $.getJSON link5, (data5) ->
                                            if data5
                                              $tr5 = makeTableRow "#{pi1}#{pi2}#{pi3}#{pi4}#{pi5}000000", data5, value5, 'depth-5', 'Организация'

                                              $('.pull-for-trs').append $tr5
                                              $(".row-#{pi1}#{pi2}#{pi3}#{pi4}#{pi5}000000").insertAfter $table.find('.'+session).find(".row-#{pi1}#{pi2}#{pi3}#{pi4}00000000")
                                              
                                              medPrograms = data5.ids.med_programs
                                              positions = data5.ids.children
                                              # positions = if doctorsChosen.length then doctorsChosen else data5.ids.children

                                              t++

                                              if positions.length
                                                $.each positions, (index6, value6) ->
                                                  i6 = index6 + 1
                                                  pi6 = pad i6
                                                  link6 = host + '/reports/search?report=4&inquiry=6&ids=' + medPrograms + '&value=' + value6

                                                  $.getJSON link6, (data6) ->
                                                    if data6
                                                      $tr6 = makeTableRow "#{pi1}#{pi2}#{pi3}#{pi4}#{pi5}#{pi6}0000", data6, value6, 'depth-6', 'Должность'

                                                      $('.pull-for-trs').append $tr6
                                                      $(".row-#{pi1}#{pi2}#{pi3}#{pi4}#{pi5}#{pi6}0000").insertAfter $table.find('.'+session).find(".row-#{pi1}#{pi2}#{pi3}#{pi4}#{pi5}000000")

                                                      medPrograms = data6.ids.med_programs
                                                      doctors = data6.ids.children

                                                      t++

                                                      if doctors.length
                                                        $.each doctors, (index7, value7) ->
                                                          i7 = index7 + 1
                                                          pi7 = pad i7
                                                          link7 = host + '/reports/search?report=4&inquiry=7&ids=' + medPrograms + '&value=' + value7

                                                          $.getJSON link7, (data7) ->
                                                            if data7
                                                              $tr7 = makeTableRow "#{pi1}#{pi2}#{pi3}#{pi4}#{pi5}#{pi6}#{pi7}00", data7, value7, 'depth-7', 'Лечащий врач'

                                                              $('.pull-for-trs').append $tr7
                                                              $(".row-#{pi1}#{pi2}#{pi3}#{pi4}#{pi5}#{pi6}#{pi7}00").insertAfter $table.find('.'+session).find(".row-#{pi1}#{pi2}#{pi3}#{pi4}#{pi5}#{pi6}0000")

                                                              medPrograms = data7.ids.med_programs
                                                              patients = data7.ids.children

                                                              t++

                                                              if patients.length
                                                                $.each patients, (index8, value8) ->
                                                                  i8 = index8 + 1
                                                                  pi8 = pad i8
                                                                  link8 = host + '/reports/search?report=4&inquiry=8&ids=' + medPrograms + '&value=' + value8
                                                                  
                                                                  $.getJSON link8, (data8) ->
                                                                    if data8
                                                                      additional =
                                                                        link: host + '/people/' + value8
                                                                        medProgram: data8.ids.children

                                                                      $tr8 = makeTableRow "#{pi1}#{pi2}#{pi3}#{pi4}#{pi5}#{pi6}#{pi7}#{pi8}", data8, value8, 'depth-8', 'Пациент', additional

                                                                      $('.pull-for-trs').append $tr8
                                                                      $(".row-#{pi1}#{pi2}#{pi3}#{pi4}#{pi5}#{pi6}#{pi7}#{pi8}").insertAfter $table.find('.'+session).find(".row-#{pi1}#{pi2}#{pi3}#{pi4}#{pi5}#{pi6}#{pi7}00")

                                                                      t++
              return
            return

        $table.show()

        false

    if fifth.length
      inputs = $('.datepicker')

      inputs.datepicker
        format: 'dd.mm.yyyy'
        language: 'ru'
        autoclose: true
        todayHighlight: true
        startView: 1,
        minViewMode: 1

      input = inputs.eq(0)

      input.parent('div').append('<span class="form-control-period">Период</span>')

      moment.lang('ru', {
          months : [
            "Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"
          ]
      });

      moment.lang('ru');

      applyMonth = (date) ->
        month = moment(date, 'DD.MM.YYYY').format('MMMM YYYY')
        span.text(month)

      span = $('.form-control-period')
      if input.data 'value'
        applyMonth input.data('value')
        input.val input.data('value')

      input.change ->
        date = input.val()
        applyMonth date

    if dataExport.length
      inputs = $('.datepicker')

      inputs.datepicker
        format: 'dd.mm.yyyy'
        language: 'ru'
        autoclose: true
        todayHighlight: true
        # endDate: moment().format('[tomorrow]')

      $form = $('form')
      $subject = $('#subject_id')
      $beginDate = $('#_begin_date')
      $endDate = $('#_end_date')

      $form.submit ->
        if $subject.val() > 0 && $beginDate.val().length != 0 && $endDate.val().length != 0
          true
        else
          alert 'Выберите "Субъект" и период для формирования отчета'
          false

    if newDataExport.length
      $tableFilled = $('#table-filled-patients')
      $tableUnfilled = $('#table-unfilled-patients')
      $message = $('#data-export-message')
      $createBtn = $('#create-report')

      $unfilledContainer = $('#unfilled-patients-container')
      $filledContainer = $('#filled-patients-container')
      unfilledPatients = []
      filledPatients = []

      link = $(location).attr 'href'

      $unfilledContainer.hide()

      updateMessage = () ->
        if unfilledPatients.length != 0
          $message.html "Количество пациентов с незаполненными данными: #{unfilledPatients.length}.<br />Заполните информацию о каждом из них, прежде чем формировать отчет."

      updateButton = () ->
        if unfilledPatients.length != 0
          $unfilledContainer.show()
        else
          $createBtn.attr 'disabled', false
          $message.text "Пациенты с незаполненными данными отсутствуют, можете формировать отчет."

      appendTo = (table, patient, program) ->
        link = encodeURIComponent $(location).attr('pathname') + $(location).attr('search')
        table.find('tbody').append """
          <tr class="tr-href" data-link="/people/#{patient.id}/edit?back_url=#{link}">
            <td>
              <div class="big">
                #{patient['full_name']}
              </div>
            </td>
            <td class="text-center">
              <div class="small">
                Начало программы
              </div>
              #{patient['date_start']}
            </td>
            <td class="text-center">
              <div class="small">
                Начало периода
              </div>
              #{program['period_start']}
            </td>
            <td class="text-center">
              <div class="small">
                Окончание периода
              </div>
              #{program['period_end']}
            </td>
          </tr>
        """

      if $tableFilled.length || $tableUnfilled.length
        $.getJSON link, (data) ->
          patients = data.patients
          if patients
            l = patients.length - 1
            patients.forEach (chunk, i) ->
              patient = chunk.patient
              id = patient.id
              unfilled = false
              values = _.values(patient)
              if _.compact(values).length != values.length
                unfilled = true

              if unfilled
                unfilledPatients.push id
                appendTo $tableUnfilled, patient, chunk.med_program
              else
                filledPatients.push id

              updateMessage()

              if i == l
                updateButton()
                tds = $('.tr-href').find('td').click ->
                  window.location = $(this).parent('tr').data('link')
                  return
