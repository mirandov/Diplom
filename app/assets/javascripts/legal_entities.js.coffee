$ ->
  $add  = $('#new-legal-entity')
  $edit = $('#edit-legal-entity')
  $list = $('#legal-entities-list')
  host  = $(location).attr 'origin'

  $flashBlock  = $('.flash-block')

  $flash = (text) ->
    name = 'flash-' + new Date().getTime()
    $flashBlock.prepend(
      """
        <div class="#{name} alert alert-dismissible alert-alert fade in">
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
    ), 7000

  getSubjects = (regionId, subjectId, blank) ->
    blank ||= ''
    $subject.find('option').remove()

    link = host + '/legal_entities?val=' + regionId
    $.getJSON link, (subjects) ->
      if subjects
        opts = []
        opts.push '<option value>' + blank + '</option>'
        _.each subjects, (subject) ->
          opts.push """<option value='#{subject.id}'>#{subject.name}</option>"""

        $subject.append opts
        if subjectId
          $subject.val subjectId

  if $add.length || $edit.length
    # types:  1 - Medical
    #         2 - Insurance
    #         3 - Other

    type = ''

    $form = $('form')
    result = true

    formControl = $('.form-control')

    $type = $('#legal_entity_type')
    $link = $('#insurance-companies-link')
    $commonData = $('#legal-entity-common-data')
    $additionalDataTitle = $('#legal-entity-additional-data')

    $medical   = $('#legal_entity_med_organization')
    $insurance = $('#legal_entity_insurance_organization')

    $shortName  = $('#legal_entity_name')
    $fullName   = $('#legal_entity_full_name')
    $ogrn       = $('#legal_entity_ogrn')
    $inn        = $('#legal_entity_inn')
    $kpp        = $('#legal_entity_kpp')
    $legalAddress    = $('#legal_entity_legal_address')
    $physicalAddress = $('#legal_entity_physical_address')
    $email          = $('#legal_entity_email')
    $phone          = $('#legal_entity_phone')
    $contactPerson  = $('#legal_entity_contact_person')

    $region    = $('#legal_entity_region_id')
    $subject   = $('#legal_entity_subject_id')
    $channel   = $('#legal_entity_channel')

    $insuranceCode      = $('#legal_entity_insurance_company_code')
    $registrationDate   = $('#legal_entity_registration_date')
    $license            = $('#legal_entity_license')
    $generalManager     = $('#legal_entity_general_manager')
    $contractNumber     = $('#legal_entity_number_of_contract')
    $contractIssueDate  = $('#legal_entity_contract_issue_date')

    $ogrn.mask '9999999999999', { placeholder: '' }
    $inn.mask '9999999999', { placeholder: '' }
    $kpp.mask '999999999', { placeholder: '' }
    $insuranceCode.mask '99999', { placeholder: '' }

    allFields = [
      $shortName,
      $fullName,
      $ogrn,
      $inn,
      $kpp,
      $legalAddress,
      $physicalAddress,
      $email,
      $phone,
      $contactPerson,
      $region,
      $subject,
      $channel,
      $insuranceCode,
      $registrationDate,
      $license,
      $generalManager,
      $contractNumber,
      $contractIssueDate
    ]

    allAdditionalFields = [
      $region,
      $subject,
      $channel,
      $insuranceCode,
      $registrationDate,
      $license,
      $generalManager,
      $contractNumber,
      $contractIssueDate
    ]

    medicalFields = [
      $region,
      $subject,
      $channel
    ]

    insuranceFields = [
      $region,
      $subject,
      $insuranceCode,
      $registrationDate,
      $license,
      $generalManager,
      $contractNumber,
      $contractIssueDate
    ]

    hide = (fields) ->
      $additionalDataTitle.hide()
      for field in fields
        field.val('') if $add.length
        field.parents('.form-group').hide()

    show = (fields) ->
      $additionalDataTitle.show()
      field.parents('.form-group').show() for field in fields

    removeHasErrorAndClear = (fields) ->
      for field in fields
        field.val('') if field.val() != ''
        $row = field.parents('.form-group')
        $row.removeClass('has-error') if $row.hasClass('has-error')

    changeType = (t) ->
      if $add.length
        $medical.prop 'checked', false
        $insurance.prop 'checked', false
        removeHasErrorAndClear allFields
      hide allAdditionalFields
      $link.hide()

      switch t
        when '1'
          $medical.prop('checked', true) if $add.length
          $commonData.show()
          show medicalFields
        when '2'
          $insurance.prop('checked', true) if $add.length
          $commonData.show()
          $link.show()
          show insuranceFields
        when '3'
          $commonData.show()
        else
          $commonData.hide()

    check = (fields) ->
      for field in fields
        if field.val() == '' && field.attr('readonly') != 'undefined'
          field.parents('.form-group').addClass 'has-error'
          result = false

    checkUnique = (input, type) ->
      link = '/legal_entities/check_unique?type=' + type + '&value=' + input.val()
      $.ajax(
        url: link
        type: 'GET'
        dataType: 'json'
      ).done (respond) ->
        if !respond.result
          input.val('')
          $flash 'Огранизация с указанным номером уже присутствует в системе'

    if $region.val().length
      subjectId = if $subject.val().length then $subject.val() else false
      getSubjects $region.val(), subjectId
    else
      $subject.find('option').remove()

    $region.change ->
      value = $(this).val()
      getSubjects value, false

    if $add.length
      $type.change ->
        type = $(this).val()
        changeType type
      changeType $type.val()
    else
      if $medical.prop 'checked'
        type = '1'
      else if $insurance.prop 'checked'
        type = '2'
      else
        type = '3'
      $type.val type
      changeType type

    formControl.bind 'change', (e) ->
      input = $(this)
      $row = input.parents('.form-group')

      if input && e.type == 'change' && $row.hasClass 'has-error'
        $row.removeClass 'has-error'

      switch type
        when '1'
          if input.prop('id') == $inn.prop('id')
            if input.val().length
              checkUnique input, 'inn'
                  
        when '2'
          if input.prop('id') == $insuranceCode.prop('id')
            if input.val().length
              checkUnique input, 'code'

    $form.submit ->
      result = true

      if type == ''
        checkSelect $type
        $flash 'Выберите тип организации'
      else
        switch type
          when '1'
            check [
              $shortName,
              $fullName,
              $ogrn,
              $inn,
              $kpp,
              $region,
              $subject,
              $channel,
            ]
          when '2'
            check [
              $shortName,
              $fullName,
              $region,
              $subject,
              $insuranceCode,
              $registrationDate,
              $license,
              $generalManager,
              # $contractNumber,
              # $contractIssueDate
            ]
          when '3'
            check [
              $shortName,
              $fullName,
              $ogrn,
              $inn,
              $kpp
            ]

        if result
          return true
        else
          $flash 'Заполните поля, выделеные красным'
          false

      false

  if $list.length
    $form    = $('#legal_entity_search')
    $org     = $('#q_med_organization')
    $region  = $('#q_region_id')
    $subject = $('#q_subject_id')
    blank    = 'Все субъекты'

    checkRegion = () ->
      if $region.val().length
        $subject.prop 'disabled', false
      else
        $subject.prop 'disabled', true

    checkOrg = () ->
      if $org.val() == 'true'
        $region.prop 'disabled', false
      else
        $region.prop 'disabled', true

      checkRegion()
      return

    if $region.val().length
      subjectId = if $subject.val().length then $subject.val() else false
      getSubjects $region.val(), subjectId, blank
      checkRegion()

    $org.change ->
      checkOrg()
      checkRegion()
      if $org.val() != 'true'
        $form.submit()
        $region.val('0')
        $subject.val('0')
      $(this).blur()
      return

    $region.change ->
      value = $(this).val()
      getSubjects value, false, blank
      checkRegion()
      $(this).blur()
      return

    checkOrg()

  return
