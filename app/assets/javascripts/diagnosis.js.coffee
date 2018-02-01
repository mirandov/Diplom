$ ->
  host  = $(location).attr 'origin'

  $modal = $('#choose-diagnosis')
  $flashBlock  = $('.flash-block')

  flash = (text) ->
    name = 'flash-' + new Date().getTime()
    $flashBlock.prepend(
      """
        <div class="#{name} alert alert-dismissible alert-notice text-left fade in">
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

  if $modal.length
    $diagnosisInput = $('#diagnosis_mkb_class_id')
    $diagnosisInput = $('#med_program_diagnoses_attributes_0_mkb_class_id')  if !$diagnosisInput.length

    $sequelaInput   = $('#diagnosis_other_mkb_classes')
    $sequelaInput   = $('#med_program_diagnoses_attributes_0_other_mkb_classes')  if !$sequelaInput.length

    $chooseDiagnosis= $('#choose-mkb_class')
    $chooseSequela  = $('#choose-other_mkb_classes')
    $diagnosisHint  = $('#chosen-mkb_class')
    $sequelaHint    = $('#chosen-other_mkb_classes')
    $list           = $('#diagnoses-list')
    $search         = $('.diagnosis-search')
    $searchResult   = $('#diagnoses-search-results')
    $chosen         = $('.diagnoses-chosen-list')
    $showList       = $('#show-list')
    $ok             = $('#ok')
    $submit         = $('input[type="submit"]')
    $cancel         = $('#cancel')
    PERSON_ID       = $list.attr('person_id')
    multiple        = false
    list            = true
    ID              = []
    IDs             = []
    tempID          = []
    tempIDs         = []

    $searchResult.hide()
    $diagnosisHint.hide()
    $sequelaHint.hide()

    updateChosen = () ->
      $div = $('<div/>')
      arr = []

      $parent = if list then $list else $searchResult

      $chosen.find('div').remove()

      if multiple
        arr = tempIDs
      else
        arr = tempID

      if arr.length > 0
        $div.append """
          <h5>Выбрано:</h5>
        """

        $.each arr, (i, d) ->
          $t = """
            <p>
              #{d[1]} - #{d[2]}
              <span class="remove-diagnosis pull-right icon icon-logout" data-id="#{d[0]}"></span>
            </p>
          """
          $div.append $t

      else
        $div.append """
          <h5 class="text-center">Диагноз не выбран</h5>
        """

      $chosen.append $div
      $('.remove-diagnosis').click ->
        id = $(this).data('id')
        equal = (e) ->
          return e[0] == id
        if multiple
          $parent.find('.diagnosis-title.active').parent('div').each ->
            if $(this).attr('id') == id.toString()
              $(this).find('.diagnosis-title').removeClass('active')
          tempIDs.splice tempIDs.findIndex(equal), 1
        else
          $parent.find('.diagnosis-title').removeClass 'active'
          tempID = []

        updateChosen()

    drawList = (data, i) ->
      id       = data.id
      name     = data.name
      code     = data.code
      parentId = data.parent_id
      children = data.node_count
      i      ||= null

      $id      = ''
      $subsBlock = ''

      $parent = if list then $list else $searchResult

      if i
        $id = """
          <span>
            #{i}.
          </span>
        """

      if children > 0
        $subsBlock = """
          <div class="diagnosis-subs"></div>
        """

      $tr = """
        <div class="diagnosis-row" id="#{ id }" nodes="#{ children }">
          <div class="diagnosis-title">
            <div class="name">
              #{ $id }
              #{ name }
            </div>
            <div class="code">
              #{ code }
            </div>
          </div>
          #{ $subsBlock }
        </div>
      """

      if i or not list  
        $parent.append $tr
      else
        $parent.find("##{ parentId }").children(".diagnosis-subs").append $tr

      $row   = $parent.find("##{ id }")
      $title = $row.children '.diagnosis-title'
      $subs  = $row.children '.diagnosis-subs'

      $title.click ->
        length = $subs.find('div').length

        if $row.attr('nodes') == '0'
          if $(@).hasClass 'active'
            if multiple
              tempIDs.splice tempIDs.indexOf(id), 1
            else
              tempID = []
              $parent.find('.diagnosis-title').removeClass 'active'
          else
            text = 'Вы выбрали <strong>' + code + ' – ' + name + '</strong>.'
            if multiple
              tempIDs.push [id, code, name]
              flash text + '<br/>После выбора необходимых позиций, нажмите "Ок" для подтверждения.'
            else
              $parent.find('.diagnosis-title').removeClass 'active'
              tempID = []
              tempID.push [id, code, name]
              flash text + '<br/>Далее нажмите "Ок" для подтверждения.'

          $(@).toggleClass 'active'
          updateChosen()
        else
          $(@).toggleClass 'open'
          $subs.toggle()

          if length == 0
            link = host + '/people/'+PERSON_ID+'/diagnoses?parent=' + id
            $.getJSON link, (data) ->
              if data
                data = data.sort (a, b) ->
                  a.id - b.id
                $.each data, (i, d) ->
                  drawList d


    link0 = host + '/people/'+PERSON_ID+'/diagnoses?parent=nil'
    $.getJSON link0, (data0) ->
      if data0
        data0 = data0.sort (a, b) ->
          a.id - b.id
        $.each data0, (i, d0) ->
          drawList d0, i+1

          link1 = host + '/people/'+PERSON_ID+'/diagnoses?parent=' + d0.id
          $.getJSON link1, (data1) ->
            if data1
              data1 = data1.sort (a, b) ->
                a.id - b.id
              $.each data1, (i, d1) ->
                drawList d1

            else
              alert 'Не удается загрузить список классов'
      else
        alert 'Не удается загрузить список диагнозов'

    $ok.click ->
      $list.find('.diagnosis-title').removeClass 'open'
      $list.find('.diagnosis-subs').hide()

      if multiple
        IDs = tempIDs
        $sequelaHint.find('div').remove()
        if IDs.length
          i = $.map(IDs, (n, i) ->
            n[0]
          )
          $sequelaInput.val i.join(',')

          IDs.forEach( (n) ->
            $sequelaHint.append """<div><strong>#{n[1]}</strong> - #{n[2]}</div>"""
          )
          $sequelaHint.show()
        else
          $sequelaInput.val ''
          $sequelaHint.hide()

      else
        $list.find('.diagnosis-title').removeClass 'active'
        ID = tempID
        $diagnosisHint.find('div').remove()
        if ID.length
          i = $.map(ID, (n, i) ->
            n[0]
          )
          $diagnosisInput.val i
          $diagnosisHint.append """<div><strong>#{ID[0][1]}</strong> - #{ID[0][2]}</div>"""
          $diagnosisHint.show()
        else
          $diagnosisInput.val ''
          $diagnosisHint.hide()

      list = true
      $search.val ''
      $searchResult.hide().find('div').remove()
      $list.show()
      $modal.modal 'hide'
      false

    $cancel.click ->
      $list.find('.diagnosis-title').removeClass('active').removeClass 'open'
      $list.find('.diagnosis-subs').hide()
      if multiple
        tempIDs = []
      else
        tempID = []

      list = true
      $search.val ''
      $searchResult.hide().find('div').remove()
      $list.show()
      $modal.modal 'hide'
      false

    $chooseDiagnosis.click ->
      multiple = false
      tempID = ID
      updateChosen()
      $modal.modal 'show'
      false

    $chooseSequela.click ->
      multiple = true
      tempIDs = IDs
      updateChosen()
      $modal.modal 'show'
      false

    $showList.click ->
      $search.blur()
      $search.val ''
      $searchResult.hide().find('div').remove()
      $list.show()
      false

    $submit.click ->
      if ID.length > 0
        return
      else
        alert 'Выберите диагноз'
        false

    $search.bind 'blur keydown', (e) ->
      if e.type == 'keydown' && e.keyCode == 13
        $search.blur()

      if e.type == 'blur'
        val = $search.val().toLowerCase()

        if val.length
          list = false
          $list.hide()
          $searchResult.show().find('div').remove()

          link = host + '/people/'+PERSON_ID+'/diagnoses?search=' + val
          $.getJSON link, (data) ->
            if data
              $.each data, (i, d) ->
                drawList d, null, false
        else
          list = true
          $searchResult.hide().find('div').remove()
          $list.show()