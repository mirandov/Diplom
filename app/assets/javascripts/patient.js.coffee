$ ->
  $patientPage = $('#patient-page')
  $flashBlock  = $('.flash-block')

  $flash = (text) ->
    $flashBlock.prepend(
      """
        <div class="alert alert-dismissible alert-notice fade in">
          <button class="close" type="button" data-dismiss="alert">
            <span aria-hidden="true">&times;</span>
          </button>
          #{text}
        </div>
      """
    )

  if $patientPage.length
    PATIENT_ID = $patientPage.attr 'patient'
    CSRF       = $('input[name="authenticity_token"]').val()
    $editData  = $('.edit-person-data')

    if $editData.length

      $editData.each ->
        $select     = $(@).find '.select'
        $select.find('select').multiselect()

        $phoneType  = $select.find '.phone-type'
        index       = $(@).attr 'index'
        phoneId     = $(@).attr 'phone_id'

        $inputPhone = $(@).find 'input.tel'
        phoneValue  = $inputPhone.val()

        $inputBirthday = $(@).find 'input.birthday'
        birthdayValue  = $inputBirthday.val()

        p = false

        updatePhoneType = (phoneType) ->
          p = false
          $.ajax
            type: 'PATCH'
            url: '/people/' + PATIENT_ID
            dataType: 'JSON'
            data:
              utf8: '✓'
              authenticity_token: CSRF
              person:
                contact_phones_attributes:
                  "#{index}":
                    phone_type:   phoneType
                    phone_number: phoneValue
                    id:           phoneId
              
            success: (data) ->
              if data.status == 1
                $flash 'Тип телефона успешно изменен'
              false

        updatePhoneNumber = (phoneNumber) ->
          $.ajax
            type: 'PATCH'
            url: '/people/' + PATIENT_ID
            dataType: 'JSON'
            data:
              utf8: '✓'
              authenticity_token: CSRF
              person:
                contact_phones_attributes:
                  "#{index}":
                    phone_number: phoneNumber
                    id:           phoneId
              
            success: (data) ->
              if data.status == 1
                $flash 'Номер телефона успешно изменен'
              false

        updateBirthday = (birthday) ->
          p = false
          $.ajax
            type: 'PATCH'
            url: '/people/' + PATIENT_ID
            dataType: 'JSON'
            data:
              utf8: '✓'
              authenticity_token: CSRF
              person:
                birthday: birthday
              
            success: (data) ->
              if data.status == 1
                $flash 'Поле "День рождения" успешно изменено'
              false

        checkPhone = (input) ->
          input.addClass 'clickable'
          val = $inputPhone.val()
          if val.includes '_'
            $inputPhone.val phoneValue
          else
            updatePhoneNumber val

        $select.change ->
          typeVal = $select.find('select option:selected').text()
          typeId  = $select.find('select option:selected').val()
          $phoneType.text " (#{typeVal})"
          if p
            p = false
            updatePhoneType typeId

        $select.bind 'click', (e) ->
          if e.type is 'click'
            p = true

        $inputPhone.bind 'click blur keydown', (e) ->
          $this = $(@)
          if e.type is 'click' and $inputPhone.hasClass 'clickable'
            $this.removeClass 'clickable'

          if e.type is 'keydown' and e.keyCode is 13
            $this.blur()
            false

          if e.type is 'blur'
            checkPhone $this

        $inputBirthday.bind 'click blur keydown', (e) ->
          $this = $(@)
          if e.type is 'click' and $inputPhone.hasClass 'clickable'
            $this.removeClass 'clickable'

          if e.type is 'keydown' and e.keyCode is 13
            $this.blur()
            false

          if e.type is 'blur'
            p = true

        $inputBirthday.change ->
          $this = $(@)
          if p
            updateBirthday $this.val()
