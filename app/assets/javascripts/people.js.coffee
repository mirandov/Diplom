$ ->
  # Show specific blocks for roles on new person page
  newPerson     = $('#new-person')
  editPerson    = $('#edit-person')
  stepOne       = $('#step-one')
  addData       = $('#add-data')

  if newPerson.length || editPerson.length || stepOne.length || addData.length

    $patientBlock        = $('.patient-settings')
    $organisationBlock   = $('.organisation-settings')
    $doctorBlock         = $('.doctor-settings')
    $employeeNumberBlock = $('.employee-number')
    $rolesInput          = $('.person_roles')
    $rolesCheckboxes     = $rolesInput.find(':checkbox')
    $formControl         = $('.form-control')
    $form                = $('form')
    $submit              = $(':submit')

    result = true
    checkInsuranceSeries = true
    checkDocumentSeries  = true

    $personSurname    = $('#person_surname')
    $personName       = $('#person_name')
    $personPatronymic = $('#person_patronymic')
    $personBirthday   = $('#person_birthday')
    $personID         = $('#person_existing_id')
    $personMale       = $('#person_male_true')
    $personFemale     = $('#person_male_false')

    $phoneList        = $('#phone-list')

    $personHeight     = $('#person_height')
    $personWeight     = $('#person_weight')
    $personContName   = $('#person_c_name')
    $personContPhone  = $('#person_c_phone')
    $personSnils            = $('#person_snils')
    $personSocialStatus     = $('#person_social_status')
    $personExemption        = $('#person_exemption')

    $personEmail      = $('#person_user_attributes_email')
    $personPass       = $('#person_user_attributes_password')
    $personPassConf   = $('#person_user_attributes_password_confirmation')
    personAccount     = $personEmail.attr 'account'

    $personOrg        = $('#person_legal_entity_id')
    $employeeNumber   = $('#person_inner_number')

    documentType      = $('#person_passport_type_id')
    documentSeries    = $('#person_passport_series')
    documentNumber    = $('#person_passport_number')

    documentFields    = [
      documentSeries
      documentNumber
    ]

    insuranceType     = $('#person_insurance_type_id')
    insuranceSeries   = $('#person_insurance_series')
    insuranceNumber   = $('#person_insurance_number')
    insuranceCompany  = $('#person_insurance_company_id')

    insuranceFields   = [
      insuranceSeries
      insuranceNumber
      insuranceCompany      
    ]

    $exemptions        = $('.exemption')
    $exemption         = $('#person_exemption')

    # $.mask.placeholder = ' '
    $.mask.definitions['R'] = '[I, V, X, L, C]'
    $.mask.definitions['S'] = '[0-9A-ZА-Я]'
    $.mask.definitions['Б'] = '[А-Я]'

    $.mask.definitions['E'] = '[0-9A-Za-zА-Яа-я]'

    $personHeight.mask '999', { placeholder: ' ' }
    $personWeight.mask '99?9', { placeholder: ' ' }

    settings =
      hideBlocks: ->
        $patientBlock.hide()
        $organisationBlock.hide()
        $employeeNumberBlock.hide()
        $doctorBlock.hide()
      show: (block) ->
        switch block
          when 'patient'
            @.patient = true
            $patientBlock.show()
          when 'doctor'
            @.doctor = true
            $doctorBlock.show()
          when 'organisation'
            @.organisation = true
            $organisationBlock.show()
          when 'employeeNumber'
            @.employeeNumber = true
            $employeeNumberBlock.show()
      reset: ->
        @.patient        = false
        @.doctor         = false
        @.organisation   = false
        @.employeeNumber = false
        @.hideBlocks()
      patient:        undefined
      doctor:         undefined
      organisation:   undefined
      employeeNumber: undefined

    settings.reset()

    getRoles = () ->
      $form.attr('person-roles').split(' ')

    updateBlocks = () ->
      settings.reset()

      r = getRoles()
      r.forEach (role) ->
        if role == 'patient'
          settings.show 'patient'
        if role == 'admin' ||
           role == 'operator' ||
           role == 'doctor' ||
           role == 'head_doctor' ||
           role == 'nurse' ||
           role == 'doctor_fd' ||
           role == 'tech_specialist' ||
           role == 'director' ||
           role == 'production_manager'
          settings.show 'organisation'
        if role == 'operator' ||
           role == 'doctor_fd'
          settings.show 'employeeNumber'
        if role == 'doctor'
          settings.show 'doctor'

    updateRoles = () ->
      arr = []
      $rolesCheckboxes.each ->
        role    = $(this).val()
        checked = $(this).prop 'checked'

        if checked
          arr.push role

      if $rolesCheckboxes.length
        $form.attr('person-roles', arr.join(' '))

      updateBlocks()

    checkInput = (e) ->
      if e.val().length == 0 && e.attr('readonly') != 'undefined'
        e.parents('.form-group').addClass 'has-error'
        result = false
      return

    checkSelect = (e) ->
      if e.val() == '' && e.attr('readonly') != 'undefined'
        e.parents('.form-group').addClass 'has-error'
        result = false
      return 

    settings.reset()

    $formControl.bind 'change', (e) ->
      $input = $(this)
      $row = $input.parents('.form-group')

      if $input && e.type == 'change' && $row.hasClass 'has-error'
        $row.removeClass 'has-error'

    if newPerson.length
      $rolesCheckboxes.change( ->
        updateRoles()
      )

    if editPerson.length
      updateRoles()
      $rolesCheckboxes.change( ->
        updateRoles()
      )

    $submit.click ->
      result = true

      if newPerson.length || editPerson.length
        checkedCheckboxes = $rolesInput.find ':checked'

        checkInput $personSurname
        checkInput $personName
        checkInput $personPatronymic
        checkInput $personBirthday

        # [!] for a future use
        # if settings.employeeNumber
        #   checkInput $employeeNumber

        # [!] for a future use
        # if settings.doctor
        #   checkInput $doctor

        if settings.organisation
          checkSelect $personOrg
          checkInput  $personEmail

          if $personEmail.val().length > 0
            if personAccount == 'false'
              checkInput  $personPass
              checkInput  $personPassConf

        if settings.patient
          ( ->
            l = $phoneList.children('div').length
            i = 0

            while i < l
              $input = $("#person_contact_phones_attributes_#{i}_phone_number")
              $type  = $("#person_contact_phones_attributes_#{i}_phone_type")

              if $input.val().length == 0
                $input.parent().addClass 'has-error'
                result = false

              if $type.val() == 'default'
                $type.parent().addClass 'has-error'
                result = false
              i++
          )()

          # [#1]
          checkInput    $personSnils
          checkSelect   documentType
          if checkDocumentSeries
            checkInput  documentSeries
          checkInput    documentNumber
          checkSelect   insuranceType
          if checkInsuranceSeries
            checkInput  insuranceSeries
          checkInput    insuranceNumber
          checkSelect   insuranceCompany
          checkSelect   $personSocialStatus
          checkSelect   $exemption

          if $personEmail.val().length > 0
            if personAccount == 'false'
              checkInput  $personPass
              checkInput  $personPassConf

      if addData.length
        # [#1]
        checkInput    $personSnils
        checkSelect   documentType
        if checkDocumentSeries
          checkInput  documentSeries
        checkInput    documentNumber
        checkSelect   insuranceType
        if checkInsuranceSeries
          checkInput  insuranceSeries
        checkInput    insuranceNumber
        checkSelect   insuranceCompany
        checkSelect   $personSocialStatus
        checkSelect   $exemption

      # console.log $rolesCheckboxes
      if (newPerson.length || editPerson.length) && $rolesCheckboxes.length && checkedCheckboxes.length == 0
        alert 'Выберите "Права" для пользователя'
        false
      else
        if !result
          alert 'Заполните обязательные поля выделеные красным'
          false
        else
          return

    # This is used on add_data page
    if documentType.length || insuranceType.length

      if documentType.length
        option = documentType.find('option[value=1]')
        documentType.find('option[value=14]').insertBefore option
        documentType.find('option[value=15]').insertBefore option

      disable = (fields) ->
        field.addClass('disabled') for field in fields
        return

      enable = (fields) ->
        for field in fields
          field.removeClass('disabled') if field.hasClass('disabled')
          field.attr 'disabled', false
        return

      clear = (fields) ->
        field.val('') for field in fields
        return

      unmask = (fields) ->
        field.unmask() for field in fields
        return

      documentTypeSwitch = (value, wasChanged = false) ->
        s = (v) ->
          documentSeries.mask v

        n = (v) ->
          documentNumber.mask v

        disableField = () ->
          documentSeries.addClass 'disabled'
          documentSeries.parents('.form-group').removeClass 'has-error'
          checkDocumentSeries = false

        focusOnSeries = () ->
          documentSeries.focus() if wasChanged

        focusOnNumber = () ->
          documentNumber.focus() if wasChanged

        switch value
          when '14'
            s '99 99'
            n '99999?9'
            focusOnSeries()

          when '15'
            s '99'
            n '9999999'
            focusOnSeries()

          when '1', '3'
            s 'R-ББ'
            n '999999'
            focusOnSeries()

          when '2', '5'
            s 'S'
            n '9?9999999'
            checkDocumentSeries = false
            focusOnSeries()

          when '4'
            s 'ББ'
            n '9999999'
            focusOnSeries()

          when '6', '17'
            s 'ББ'
            n '999999'
            focusOnSeries()

          when '7'
            s 'ББ'
            n '999999?9'
            focusOnSeries()

          when '8', '25'
            s '99'
            n '9999999'
            focusOnSeries()

          when '9', '10', '11', '12', '13', '21', '22', '23', '24', '27', '28', '29'
            s 'S'
            n '9?99999999999'
            checkDocumentSeries = false
            focusOnSeries()

          when '16'
            s 'ББ'
            n '99999?9'
            focusOnSeries()

          when '18'
            s 'S'
            n '9?999999999'
            checkDocumentSeries = false
            focusOnSeries()

          when '26'
            n '999999'
            disableField()
            focusOnNumber()

          else
            unmask documentFields

      insuranceTypeSwitch = (value, wasChanged = false) ->
        s = (v) ->
          insuranceSeries.mask v

        n = (v) ->
          insuranceNumber.mask v

        disableField = () ->
          insuranceSeries.addClass 'disabled'
          insuranceSeries.parents('.form-group').removeClass 'has-error'
          checkInsuranceSeries = false

        focusOnSeries = () ->
          insuranceSeries.focus() if wasChanged

        focusOnNumber = () ->
          insuranceNumber.focus() if wasChanged

        switch value
          when '1'
            # s 'EEEEEE'
            # n '9999999999'
            checkInsuranceSeries = false
            console.log checkInsuranceSeries
            focusOnSeries()

          when '2'
            n '999999999'
            disableField()
            focusOnNumber()

          when '3'
            n '9999999999999999'
            disableField()
            focusOnNumber()

          when '4', '5'
            focusOnSeries()

      if documentType.val() == ''
        disable documentFields
      else
        documentTypeSwitch documentType.val()

      if insuranceType.val() == ''
        disable insuranceFields
      else
        insuranceTypeSwitch insuranceType.val()

      documentType.change( ->
        clear documentFields
        unmask documentFields
        checkDocumentSeries = true

        if documentType.val() == ''
          disable documentFields
        else
          enable documentFields
          documentTypeSwitch $(this).val(), true
      )

      insuranceType.change( ->
        clear insuranceFields
        unmask insuranceFields
        checkInsuranceSeries = true

        if insuranceType.val() == ''
          disable insuranceFields
        else 
          enable insuranceFields
          insuranceTypeSwitch $(this).val(), true
      )

      $exemptions.hide()

      if $exemption.val().length
        id = $exemption.val()
        $(".exemption-#{id}").show()

      $exemption.change( ->
        $exemptions.hide()
        id = $exemption.val()
        $(".exemption-#{id}").show()
      )

      snils = $('#person_snils')
      if snils.length
        snils.mask '999-999-999 99'