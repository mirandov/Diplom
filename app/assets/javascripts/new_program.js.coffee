# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  host = $(location).attr 'origin'
  can = false

  $one = $('#step-one')
  $two = $('#step-two')
  $five = $('#step-five')

  if $one.length || $two.length || $five.length
    # Минимальная длинна фамилии, после которой может производится проверка
    minLength = 2

    formControl       = $('.form-control')

    userSurname       = $('#person_surname')
    userName          = $('#person_name')
    userPatronymic    = $('#person_patronymic')
    userBirthday      = $('#person_birthday')
    userHeight        = $('#person_height')
    userWeight        = $('#person_weight')
    userContactName   = $('#person_c_name')
    userContactPhone  = $('#person_c_phone')
    userID            = $('#person_existing_id')
    userMale          = $('#person_male_true')
    userFemale        = $('#person_male_false')

    userPhone         = $('#person_contact_phones_attributes_0_phone_number')
    userEmail         = $('#person_user_attributes_email')
    userPass          = $('#person_user_attributes_password')
    userPassConf      = $('#person_user_attributes_password_confirmation')

    userSnils             = $('#person_snils')
    userPassportType      = $('#person_passport_type_id')
    userPassportSeries    = $('#person_passport_series')
    userPassportNumber    = $('#person_passport_number')
    userInsuranceType     = $('#person_insurance_type_id')
    userInsuranceSeries   = $('#person_insurance_series')
    userInsuranceNumber   = $('#person_insurance_number')
    userInsuranceCompany  = $('#person_insurance_company_id')
    userSocialStatus      = $('#person_social_status')
    userExemption         = $('#person_exemption')

    fieldWithDropdown = userSurname.parent()

    # userSurname.focus()

    userSurname.parent('div').append '<div class="dropdown-container"></div>'

    dropdownBackground = $('.dropdown-background')
    dropdownContainer = $('.dropdown-container')
    activeDropdown = false

    toHide = $('.to-hide')

    block = $('#new_person')

    phoneList = $('#phone-list')

    result = true

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

    capitalizeFirst = (s) ->
      s.charAt(0).toUpperCase() + s.slice(1)

    naString = (v) ->
      if v == '' || v == null
        'Не указано'
      else
        v

    naNumber = (v) ->
      if v == null
        0
      else
        v

    changed = (e) ->
      e.val ''
      e.removeClass 'changed'
      return


    clearFields = (surname) ->

      clear = (f) ->
        f.val('').prop 'readonly', false

      toHide.show()

      if surname
        changed userSurname

      clear userName
      clear userPatronymic
      clear userBirthday
      clear userHeight
      clear userWeight
      # clear userAnamnesis
      clear userContactName
      clear userContactPhone
      userID.val('0').prop 'readonly', false
      userMale.prop('checked', true).parent().parent('div').removeClass 'disabled-input' 
      formControl.parents('div').removeClass 'disabled-input'

      clear userSnils

      clear userPassportType
      clear userPassportSeries.prop('disabled', true)
      clear userPassportNumber.prop('disabled', true)

      clear userInsuranceType
      clear userInsuranceSeries.prop('disabled', true)
      clear userInsuranceNumber.prop('disabled', true)
      clear userInsuranceCompany

      clear userSocialStatus
      clear userExemption

      return

    $('.autocomplete').keydown (event) ->
      if event.keyCode == 13
        event.preventDefault()
        false

    # 
    # ПЕРВЫЙ ШАГ СОЗДАНИЯ ПРОГРАММЫ
    # .changed - позволяет очищать поле, если оно не пусто, по функции changed()
    #
    if $one.length
      $submit = $('#next-step')
    
      # Не понятно для чего этот change
      change = false

      checkInsuranceSeries = true

      # keydown - для удаления введенной строки
      formControl.bind 'keydown keyup focusout change', (e) ->
        input = $(this)
        row = input.parents('.form-group')

        if input && e.type == 'change' && row.hasClass 'has-error'
          row.removeClass 'has-error'

        if input.attr('id') == 'person_surname' && (e.type == 'keydown' || e.type == 'focusout')

          # Отображение выпадающего списка
          showDropdown = () ->

            input.val capitalizeFirst(input.val().toLowerCase())
            value = input.val()

            link = host + '/people/search?field=surname&q=' + value

            # Получение данных с сервера по link
            $.getJSON link, (data) ->

              # Функция заполения полей
              fillFields = (i) ->
                user = data.users[i]

                id          = user.id
                name        = user.name
                patronymic  = naString user.patronymic
                newBirthday = user.birthday
                b           = new Date newBirthday
                birthday    = ('0' + b.getDate()).substr(-2) + '.' + ('0' + (b.getMonth() + 1)).substr(-2) + '.' + b.getFullYear()
                height      = naNumber user.height
                weight      = naNumber user.weight
                anamnesis   = naString user.anamnesis
                c_name      = naString user.c_name
                c_phone     = naString user.c_phone
                snils       = naString user.snils
                passportType    = naString user.passport_type_id
                passportSeries  = naString user.passport_series
                passportNumber  = naString user.passport_number
                insuranceType   = naString user.insurance_type_id
                insuranceSeries = naString user.insurance_series
                insuranceNumber = naString user.insurance_number
                insuranceCompany = naString user.insurance_company_id
                socialStatus     = naString user.social_status
                exemption        = naString user.exemption

                if !data.users[0].male
                  userFemale.prop 'checked', true

                addValue = (f, value) ->
                  f.val(value).prop('readonly', true).parents('.form-group').addClass('disabled-input').removeClass 'has-error'

                toHide.hide()

                addValue userName, name
                addValue userPatronymic, patronymic
                addValue userBirthday, birthday
                addValue userHeight, height
                addValue userWeight, weight
                addValue userContactName, c_name
                addValue userContactPhone, c_phone
                userID.val(id).prop 'readonly', true
                userMale.parent().parent('.form-group').addClass('disabled-input').removeClass 'has-error'

                addValue userSnils, snils

                userPassportType.val(passportType).parent('.form-group').addClass('disabled-input').removeClass 'has-error'
                addValue userPassportSeries.prop('disabled', false), passportSeries
                addValue userPassportNumber.prop('disabled', false), passportNumber

                userInsuranceType.val(insuranceType).parent('.form-group').addClass('disabled-input').removeClass 'has-error'
                addValue userInsuranceSeries.prop('disabled', false), insuranceSeries
                addValue userInsuranceNumber.prop('disabled', false), insuranceNumber
                userInsuranceCompany.val(insuranceCompany).parent('.form-group').addClass('disabled-input').removeClass 'has-error'

                userSocialStatus.val(socialStatus).parent('.form-group').addClass('disabled-input').removeClass 'has-error'
                userExemption.val(exemption).parent('.form-group').addClass('disabled-input').removeClass 'has-error'

                change = false
                return

              # Вывод списка с выбором пользователя
              if data.users.length != 0

                # Скролл к началу формы
                $(window).scrollTop(block.offset().top - $('header').outerHeight())

                dropdownBackground.fadeIn('400')

                # Объявление выпадающего списка и заголовка
                ul = dropdownContainer.append('<div class="dropdown"><p>Выберите пациента:</p><ul></ul></div>').find('ul')
                dropdown = $('.dropdown')

                dropdown.append '<a id="add-new-user">Новый пациент c фамилией "<strong>' + value + '</strong>"</a>'

                # Отрисовка каждой строки выпадающего списка
                i = 0
                arrayLength = data.users.length
                while i < arrayLength

                  ul.append '<li></li>'
                  item = ul.find 'li:last-child'

                  item.append '<a></a>'
                  anchor = item.find 'a'

                  # Представление ФИО
                  name = '<strong>' + data.users[i].surname + '</strong> ' + data.users[i].name + ' ' + data.users[i].patronymic
                  anchor.append name

                  # Представление даты рождения
                  anchor.append '<span></span>'
                  birthdayField = anchor.find 'span'
                  b = new Date(data.users[i].birthday)
                  birthday = ('0' + b.getDate()).substr(-2) + '.' + ('0' + (b.getMonth() + 1)).substr(-2) + '.' + b.getFullYear()
                  birthdayField.append birthday

                  i++

                # Функция скрытия выпадающего списка
                hideDropdown = () ->
                  dropdown.fadeOut(400)
                  dropdownBackground.fadeOut(400)

                  activeDropdown = false

                  # Удаление объекта
                  setTimeout (->
                    dropdown.remove()
                    return
                  ), 1000
                  return

                # Действие при нажатии на строку в выпадающем списке
                li = dropdown.find 'li'
                li.click ->
                  index = $(this).index()
                  fillFields index
                  hideDropdown()
                  return

                liFirst = dropdown.find 'li:first-child'

                # Ограничение по количеству строк в выпадающем списке
                numberOfItems = 6

                if arrayLength > numberOfItems
                  liHeight = liFirst.outerHeight()
                  ulHeight = liHeight * numberOfItems
                  ul.css height: ulHeight

                activeDropdown = true

                # Скрытие выпадающего списка по изменении поля Фамилия
                input.bind 'change paste keydown', (e) ->
                  if e.keyCode >= 48 && e.keyCode <= 90 || e.keyCode >= 96 && e.keyCode <= 105 || e.keyCode == 8
                    hideDropdown()

                    if input.hasClass 'changed'
                      clearFields true
                      return
                    return
                  return

                # Скрытие выпадающего списка при нажатии на кнопку  "Добавить нового пользователя"
                $('#add-new-user').click ->
                  hideDropdown()
                  userName.focus()
                  clearFields false
                  return

              # # Пользователи не найдены - переход на следующее поле
              else
                input.parent().next().find('.form-control').focus()

            can = false
            return

          surname = () ->
            if can
              if dropdownContainer.children().length >= 1
                dropdownContainer.children('div').remove()
              showDropdown()
              return
            return

          # minLength - задана в первых строках
          if input.val().length >= minLength
            if !activeDropdown
              can = true
              if e.type == 'focusout'
                surname()
                input.addClass('changed')

              if e.keyCode == 9 || e.keyCode == 13
                input.blur()

            if input.hasClass 'changed' && e.type == 'keydown'
              if e.keyCode >= 48 && e.keyCode <= 90 || e.keyCode >= 96 && e.keyCode <= 105 || e.keyCode == 8
                changed()
                toHide.show()
                clearFields()
                return
              return
            return
          return

        if e.type == 'keydown' && 
           (input.attr('id') == 'person_height' || 
           input.attr('id') == 'person_weight' ||
           input.attr('id') == 'person_anamneses_attributes_0_params_systolic_bp' ||
           input.attr('id') == 'person_anamneses_attributes_0_params_diastolic_bp' ||
           input.attr('id') == 'person_anamneses_attributes_0_params_heart_rate')

          if e.shiftKey || e.altKey ||
             e.keyCode != 8 && 
             e.keyCode != 9 &&
             e.keyCode != 0 &&
             e.keyCode != 46 &&
             (e.keyCode < 37 || e.keyCode > 40 && e.keyCode < 48 || e.keyCode > 57 && e.keyCode < 96 || e.keyCode > 105)
            e.preventDefault()
            false
          return
        return

      userInsuranceType.change(->
        if userInsuranceType.val() == '3' || userInsuranceType.val() == '1'
          checkInsuranceSeries = false
        else
          checkInsuranceSeries = true
      )

      $submit.click ->
        result = true      

        checkInput userSurname
        checkInput userName
        checkInput userPatronymic
        checkInput userBirthday

        if userName.attr('readonly') != 'readonly'
          ( ->
            l = phoneList.find('input').length
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

        checkInput userSnils

        checkSelect userPassportType
        checkInput userPassportSeries
        checkInput userPassportNumber

        checkSelect userInsuranceType
        if checkInsuranceSeries
          checkInput userInsuranceSeries
        checkInput userInsuranceNumber
        checkSelect userInsuranceCompany

        checkSelect userSocialStatus
        checkSelect userExemption

        if !result
          alert 'Заполните обязательные поля, выделеные красным.'
          false
        else
          return

    # 
    # ВТОРОЙ ШАГ СОЗДАНИЯ ПРОГРАММЫ
    # 
    if $two.length
      $template    = $('#med_program_template_id')
      $programType = $('#med_program_program_type')
      $begin       = $('#med_program_begin_date')
      $end         = $('#med_program_end_date')
      $doctor     = $('#med_program_doctor_id')

      $anamnesis = $('#med_program_anamneses_attributes_0_body')
      $SBP       = $('#med_program_anamneses_attributes_0_params_systolic_bp')
      $DBP       = $('#med_program_anamneses_attributes_0_params_diastolic_bp')
      $HR        = $('#med_program_anamneses_attributes_0_params_heart_rate')

      $diagnosisInput = $('#med_program_diagnoses_attributes_0_mkb_class_id')
      $sequelaInput   = $('#med_program_diagnoses_attributes_0_other_mkb_classes')
      $diseases       = $('med_program_diagnoses_attributes_0_diseases')      

      $complectsTypes = $('#complects_types')

      $submit = $('#next-step')

      $begin.datepicker
        format: "dd.mm.yyyy"
        startDate: $begin.attr 'begin'
        weekStart: 1
        language: "ru"
        autoclose: true
        todayHighlight: true

      # Выбор шаблона пользователем
      $template.change( ->
        value = $(this).find(":selected").val()
        link1 = host + '/med_program_templates/' + value + '.json'
        link2 = host + '/med_program_templates/complects/' + value
        $complectsTypes.addClass 'hide'

        $.getJSON link1, (data) ->

          numberOfDays = parseInt data.duration

          $begin.change () ->

            if $(this).val().length > 0
              day = 86400000
              date = new Date($(this).val().replace(/(\d{2})\.(\d{2})\.(\d{4})/, '$3-$2-$1'))
              time = date.getTime()

              if time
                date.setTime time + numberOfDays * day
                formated = 
                  ('0' + date.getDate()).substr(-2) + '.' + 
                  ('0' + (date.getMonth() + 1)).substr(-2) + '.' + 
                  date.getFullYear()

              else
                formated = ''

              $end.val formated
              return
          .change()

        $.getJSON link2, (data) ->
          if data.length != 0

            $.ajax(
              url: '/med_program_wizard/complects/' + value
              dataType: 'script'
            )

            setTimeout (->
              complectInput = $complectsTypes.find 'input'

              if complectInput.length == 1
                complectInput.attr 'checked', true
                return
              else
                $complectsTypes.removeClass 'hide'
                return

              complectInput.click () ->
                inputValue = $(this).val()
                inputCurrent = $('#complect_type_id_' + inputValue)
                return

              return
            ), 500
      )

      if $doctor.length && $doctor.children().length <= 2
        $doctor.find('option').eq(1).prop 'selected', true

      formControl.bind 'change', (e) ->
        $input = $(this)
        $row = $input.parents('.form-group')

        if $input && e.type == 'change' && $row.hasClass 'has-error'
          $row.removeClass 'has-error'

      $submit.click ->
        result = true

        checkSelect $template
        checkSelect $programType
        checkInput  $begin
        checkSelect $doctor

        checkInput  $SBP
        checkInput  $DBP
        checkInput  $HR

        if !result
          alert 'Заполните обязательные поля, выделеные красным.'
          false
        else
          return

      return


    # 
    # ПЯТЫЙ ШАГ СОЗДАНИЯ ПРОГРАММЫ
    # 
    if $five.length
      $submit = $('#next-step')
      imei = $('#med_program_ad_imei')
      complectId = $('#med_program_complect_id')

      $('.table-selectable tr').click ->
        row = $(this) 

        $('tr.active').removeClass 'active'

        $('.search-field').keyup (e) ->
          if e.keyCode == 8
            $('tr.active').removeClass 'active'
            row.addClass 'active'

        row.addClass 'active'

        id = row.find('td').eq(0).text()
        $('#med_program_complect_id').val id

        x = row.find('td ul:last-child li').size()

        text = 'Выбран комплект <strong>№' + id + '</strong>.'
        $('#choosen-complect').html text

        i = 0

        while i < x
          name = row.find('td ul li').eq(i).attr 'data-name'
          check = name.search "Модуль GSM"

          if check >= 0

            imeiID = row.find('td ul li').eq(i).attr 'data-number'          
            imei.val imeiID
            return

          i++
        return

      if $('#complects-list').length
        complectsOptions = valueNames: [
          'complect-id'
        ]
        complectsList = new List('step-five', complectsOptions)

      $submit.click ->
        if parseInt(complectId.val()) == 0
          alert 'Выберите Комплект'
          false
        else
          return

      return
