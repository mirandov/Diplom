$ ->
  phoneBeginName = 'contact_phones_attributes'
  phoneNumEnd   = 'phone_number'
  phoneTypeEnd  = 'phone_type'

  phoneList = $('#phone-list')

  phoneMask = () ->
    phoneForm = $('.tel')
    phoneForm.mask '+7 (999) 999-99-99'

  phoneMask()

  $("#add-phone").click (event) ->

    event.preventDefault()

    name = className = id = ''

    if phoneList.find('.phone-item').length == 0 && phoneList.find('.first-phone-item').length == 0
      id = 0
      name = 'Телефон'
      className = 'first-phone-item'
    else
      phoneItems = phoneList.find('.phone-item').length
      additionalPhone = phoneList.find $('.additional-phone')
      id = phoneItems + additionalPhone.length
      name = 'Доп. Телефон ' + id
      className = 'additional-phone'

    newInput = $("""
      <div class="#{className}">
        <div class="form-group string optional phone person_contact_phones_phone_number">
          <label class="text-right control-label" for="person_#{phoneBeginName}_#{id}_#{phoneNumEnd}">#{name}</label>
          <span class="icon icon-logout remove-phone remove-phone-btn"></span>
          <input type="tel" name="person[#{phoneBeginName}][#{id}][#{phoneNumEnd}]" id="person_#{phoneBeginName}_#{id}_#{phoneNumEnd}" class="form-control tel">
        </div>
        <div class="form-group form_row enum optional person_contact_phones_phone_type">
          <label class="enum optional control-label" for="person_#{phoneBeginName}_#{id}_#{phoneTypeEnd}">Тип</label>
          <select class="enum optional form-control" name="person[#{phoneBeginName}][#{id}][#{phoneTypeEnd}]" id="person_#{phoneBeginName}_#{id}_#{phoneTypeEnd}">
            <option selected="selected" value="default">Не выбран</option>
            <option value="mobile">Мобильный</option>
            <option value="home">Домашний</option>
            <option value="job">Рабочий</option>
          </select>
        </div>
        <br/>
      </div>
    """)

    phoneList.append newInput
    phoneMask()
    newInput.find('input[type="tel"]').focus()

    $('.remove-phone').click ->
      $this = $(this)
      first = $(this).parents('.first-phone-item')
      additon = $(this).parents('.additional-phone')

      if first.length
        first.remove()

      if additon.length
        additon.remove()
      false

    return


  $('.remove-phone').click ->
    phoneItem = $(this).parents('.phone-item')

    if phoneItem
      input = phoneItem.find('.person_contact_phones__destroy').find 'input'

      if confirm('Вы действително хотите удалить этот номер телефона?')
        message = $("""
          <div class="remove-phone-message text-center">
            <p class="text">
              Для применения изменений нажмите кнопку "Сохранить"
            </p>
            <p class="text">
              или <a class="cancel-remove-phone">Отмена</a>, для отмены удаления телефона.
            </p>
            <br/>
          </div>
        """)

        input.attr 'value', true
        phoneItem.children().hide()
        phoneItem.append message

        $('.cancel-remove-phone').click ->
          phoneItem.children().show()
          phoneItem.find('.remove-phone-message').remove()
          phoneItem.find('.person_contact_phones__destroy').find('input').attr 'value', false
          false

    false

  return
