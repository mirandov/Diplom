###
# jQuery Plugin: Tokenizing Autocomplete Text Entry
# Version 1.6.0
#
# Copyright (c) 2009 James Smith (http://loopj.com)
# Licensed jointly under the GPL and MIT licenses,
# choose which one suits your project best!
###

(($) ->

  # Default settings
  DEFAULT_SETTINGS = 
    method: 'GET'
    contentType: 'json'
    queryParam: 'q'
    searchDelay: 50
    minChars: 1
    propertyToSearch: 'name'
    jsonContainer: null
    hintText: 'Type in a search term'
    noResultsText: 'No results'
    searchingText: 'Searching...'
    deleteText: '&times;'
    animateDropdown: true
    tokenLimit: null
    tokenDelimiter: ','
    preventDuplicates: false
    tokenValue: 'id'
    prePopulate: null
    processPrePopulate: false
    idPrefix: 'token-input-'
    resultsFormatter: (item) ->
      '<li>' + item[@propertyToSearch] + '</li>'
    tokenFormatter: (item) ->
      '<li><p>' + item[@propertyToSearch] + '</p></li>'
    onResult: null
    onAdd: null
    onDelete: null
    onReady: null

  # Default classes to use when theming
  DEFAULT_CLASSES = 
    tokenList: 'token-input-list'
    token: 'token-input-token'
    tokenDelete: 'token-input-delete-token'
    selectedToken: 'token-input-selected-token'
    highlightedToken: 'token-input-highlighted-token'
    dropdown: 'token-input-dropdown'
    dropdownItem: 'token-input-dropdown-item'
    dropdownItem2: 'token-input-dropdown-item2'
    selectedDropdownItem: 'token-input-selected-dropdown-item'
    inputToken: 'token-input-input-token'

  # Input box position "enum"
  POSITION = 
    BEFORE: 0
    AFTER: 1
    END: 2

  # Keys "enum"
  KEY = 
    BACKSPACE: 8
    TAB: 9
    ENTER: 13
    ESCAPE: 27
    SPACE: 32
    PAGE_UP: 33
    PAGE_DOWN: 34
    END: 35
    HOME: 36
    LEFT: 37
    UP: 38
    RIGHT: 39
    DOWN: 40
    NUMPAD_ENTER: 108

  # Additional public (exposed) methods
  methods = 
    init: (url_or_data_or_function, options) ->
      settings = $.extend({}, DEFAULT_SETTINGS, options or {})
      @each ->
        $(this).data 'tokenInputObject', new ($.TokenList)(this, url_or_data_or_function, settings)
        return
    clear: ->
      @data('tokenInputObject').clear()
      this
    add: (item) ->
      @data('tokenInputObject').add item
      this
    remove: (item) ->
      @data('tokenInputObject').remove item
      this
    get: ->
      @data('tokenInputObject').getTokens()
  # Expose the .tokenInput function to jQuery as a plugin

  $.fn.tokenInput = (method) ->
    # Method calling and initialization logic
    if methods[method]
      methods[method].apply this, Array::slice.call(arguments, 1)
    else
      methods.init.apply this, arguments

  # TokenList class for each input

  $.TokenList = (input, url_or_data, settings) ->

    #
    # Private functions
    #

    # Save the tokens
    saved_tokens = []
    # Keep track of the number of tokens in the list
    token_count = 0
    # Basic cache to save on db hits
    cache = new ($.TokenList.Cache)
    # Keep track of the timeout, old vals
    timeout = undefined
    input_val = undefined

    # Keep a reference to the selected token and dropdown item
    selected_token = null
    selected_token_index = 0
    selected_dropdown_item = null

    # Create a new text input an attach keyup events
    input_box = $('<input type="text"  autocomplete="off">').css(outline: 'none').attr('id', settings.idPrefix + input.id).focus(->
      if settings.tokenLimit == null or settings.tokenLimit != token_count
        show_dropdown_hint()
      return
    ).blur(->
      hide_dropdown()
      $(this).val ''
      return
    ).bind('keyup keydown blur update', resize_input).keydown((event) ->
      previous_token = undefined
      next_token = undefined
      switch event.keyCode
        when KEY.LEFT, KEY.RIGHT, KEY.UP, KEY.DOWN
          if !$(this).val()
            previous_token = input_token.prev()
            next_token = input_token.next()
            if previous_token.length and previous_token.get(0) == selected_token or next_token.length and next_token.get(0) == selected_token
              # Check if there is a previous/next token and it is selected
              if event.keyCode == KEY.LEFT or event.keyCode == KEY.UP
                deselect_token $(selected_token), POSITION.BEFORE
              else
                deselect_token $(selected_token), POSITION.AFTER
            else if (event.keyCode == KEY.LEFT or event.keyCode == KEY.UP) and previous_token.length
              # We are moving left, select the previous token if it exists
              select_token $(previous_token.get(0))
            else if (event.keyCode == KEY.RIGHT or event.keyCode == KEY.DOWN) and next_token.length
              # We are moving right, select the next token if it exists
              select_token $(next_token.get(0))
          else
            dropdown_item = null
            if event.keyCode == KEY.DOWN or event.keyCode == KEY.RIGHT
              dropdown_item = $(selected_dropdown_item).next()
            else
              dropdown_item = $(selected_dropdown_item).prev()
            if dropdown_item.length
              select_dropdown_item dropdown_item
            return false
        when KEY.BACKSPACE
          previous_token = input_token.prev()
          if !$(this).val().length
            if selected_token
              delete_token $(selected_token)
              hidden_input.change()
            else if previous_token.length
              select_token $(previous_token.get(0))
            return false
          else if $(this).val().length == 1
            hide_dropdown()
          else
            # set a timeout just long enough to let this function finish.
            setTimeout (->
              do_search()
              return
            ), 5
        when KEY.TAB, KEY.ENTER, KEY.NUMPAD_ENTER
          if selected_dropdown_item
            add_token $(selected_dropdown_item).data('tokeninput')
            hidden_input.change()
            return false
        when KEY.ESCAPE
          hide_dropdown()
          return true
        else
          if String.fromCharCode(event.which)
            # set a timeout just long enough to let this function finish.
            setTimeout (->
              do_search()
              return
            ), 5
          break
      return
    )

    checkTokenLimit = ->
      if settings.tokenLimit != null and token_count >= settings.tokenLimit
        input_box.hide()
        hide_dropdown()
        return
      return

    resize_input = ->
      if input_val == (input_val = input_box.val())
        return
      # Enter new content into resizer and resize input accordingly
      escaped = input_val.replace(/&/g, '&amp;').replace(/\s/g, ' ').replace(/</g, '&lt;').replace(/>/g, '&gt;')
      input_resizer.html escaped
      input_box.width input_resizer.width() + 30
      return

    is_printable_character = (keycode) ->
      keycode >= 48 and keycode <= 90 or keycode >= 96 and keycode <= 111 or keycode >= 186 and keycode <= 192 or keycode >= 219 and keycode <= 222
      # ( \ ) '

    # Inner function to a token to the list

    insert_token = (item) ->
      this_token = settings.tokenFormatter(item)
      this_token = $(this_token).addClass(settings.classes.token).insertBefore(input_token)
      # The 'delete token' button
      $('<span>' + settings.deleteText + '</span>').addClass(settings.classes.tokenDelete).appendTo(this_token).click ->
        delete_token $(this).parent()
        hidden_input.change()
        false
      # Store data on the token
      token_data = 'id': item.id
      token_data[settings.propertyToSearch] = item[settings.propertyToSearch]
      $.data this_token.get(0), 'tokeninput', item
      # Save this token for duplicate checking
      saved_tokens = saved_tokens.slice(0, selected_token_index).concat([ token_data ]).concat(saved_tokens.slice(selected_token_index))
      selected_token_index++
      # Update the hidden input
      update_hidden_input saved_tokens, hidden_input
      token_count += 1
      # Check the token limit
      if settings.tokenLimit != null and token_count >= settings.tokenLimit
        input_box.hide()
        hide_dropdown()
      this_token

    # Add a token to the token list based on user input

    add_token = (item) ->
      callback = settings.onAdd
      # See if the token already exists and select it if we don't want duplicates
      if token_count > 0 and settings.preventDuplicates
        found_existing_token = null
        token_list.children().each ->
          existing_token = $(this)
          existing_data = $.data(existing_token.get(0), 'tokeninput')
          if existing_data and existing_data.id == item.id
            found_existing_token = existing_token
            return false
          return
        if found_existing_token
          select_token found_existing_token
          input_token.insertAfter found_existing_token
          input_box.focus()
          return
      # Insert the new tokens
      if settings.tokenLimit == null or token_count < settings.tokenLimit
        insert_token item
        checkTokenLimit()
      # Clear input box
      input_box.val ''
      # Don't show the help dropdown, they've got the idea
      hide_dropdown()
      # Execute the onAdd callback if defined
      if $.isFunction(callback)
        callback.call hidden_input, item
      return

    # Select a token in the token list

    select_token = (token) ->
      token.addClass settings.classes.selectedToken
      selected_token = token.get(0)
      # Hide input box
      input_box.val ''
      # Hide dropdown if it is visible (eg if we clicked to select token)
      hide_dropdown()
      return

    # Deselect a token in the token list

    deselect_token = (token, position) ->
      token.removeClass settings.classes.selectedToken
      selected_token = null
      if position == POSITION.BEFORE
        input_token.insertBefore token
        selected_token_index--
      else if position == POSITION.AFTER
        input_token.insertAfter token
        selected_token_index++
      else
        input_token.appendTo token_list
        selected_token_index = token_count
      # Show the input box and give it focus again
      input_box.focus()
      return

    # Toggle selection of a token in the token list

    toggle_select_token = (token) ->
      previous_selected_token = selected_token
      if selected_token
        deselect_token $(selected_token), POSITION.END
      if previous_selected_token == token.get(0)
        deselect_token token, POSITION.END
      else
        select_token token
      return

    # Delete a token from the token list

    delete_token = (token) ->
      # Remove the id from the saved list
      token_data = $.data(token.get(0), 'tokeninput')
      callback = settings.onDelete
      index = token.prevAll().length
      if index > selected_token_index
        index--
      # Delete the token
      token.remove()
      selected_token = null
      # Show the input box and give it focus again
      input_box.focus()
      # Remove this token from the saved list
      saved_tokens = saved_tokens.slice(0, index).concat(saved_tokens.slice(index + 1))
      if index < selected_token_index
        selected_token_index--
      # Update the hidden input
      update_hidden_input saved_tokens, hidden_input
      token_count -= 1
      if settings.tokenLimit != null
        input_box.show().val('').focus()
      # Execute the onDelete callback if defined
      if $.isFunction(callback)
        callback.call hidden_input, token_data
      return

    # Update the hidden input box value

    update_hidden_input = (saved_tokens, hidden_input) ->
      token_values = $.map(saved_tokens, (el) ->
        el[settings.tokenValue]
      )
      hidden_input.val token_values.join(settings.tokenDelimiter)
      return

    # Hide and clear the results dropdown

    hide_dropdown = ->
      dropdown.hide().empty()
      selected_dropdown_item = null
      return

    show_dropdown = ->
      dropdown.css(
        position: 'absolute'
        top: $(token_list).offset().top + $(token_list).outerHeight()
        left: $(token_list).offset().left + 2
        width: $(token_list).innerWidth() - 4
        zIndex: 999
      ).show()
      return

    show_dropdown_searching = ->
      if settings.searchingText
        dropdown.html '<p>' + settings.searchingText + '</p>'
        show_dropdown()
      return

    show_dropdown_hint = ->
      if settings.hintText
        dropdown.html '<p>' + settings.hintText + '</p>'
        show_dropdown()
      return

    # Highlight the query part of the search term

    highlight_term = (value, term) ->
      value.replace new RegExp('(?![^&;]+;)(?!<[^<>]*)(' + term + ')(?![^<>]*>)(?![^&;]+;)', 'gi'), '<b>$1</b>'

    find_value_and_highlight_term = (template, value, term) ->
      template.replace new RegExp('(?![^&;]+;)(?!<[^<>]*)(' + value + ')(?![^<>]*>)(?![^&;]+;)', 'g'), highlight_term(value, term)

    # Populate the results dropdown with some results

    populate_dropdown = (query, results) ->
      if results and results.length
        dropdown.empty()
        dropdown_ul = $('<ul>').appendTo(dropdown).mouseover((event) ->
          select_dropdown_item $(event.target).closest('li')
          return
        ).mousedown((event) ->
          add_token $(event.target).closest('li').data('tokeninput')
          hidden_input.change()
          false
        ).hide()
        $.each results, (index, value) ->
          this_li = settings.resultsFormatter(value)
          this_li = find_value_and_highlight_term(this_li, value[settings.propertyToSearch], query)
          this_li = $(this_li).appendTo(dropdown_ul)
          if index % 2
            this_li.addClass settings.classes.dropdownItem
          else
            this_li.addClass settings.classes.dropdownItem2
          if index == 0
            select_dropdown_item this_li
          $.data this_li.get(0), 'tokeninput', value
          return
        show_dropdown()
        if settings.animateDropdown
          dropdown_ul.slideDown 'fast'
        else
          dropdown_ul.show()
      else
        if settings.noResultsText
          dropdown.html '<p>' + settings.noResultsText + '</p>'
          show_dropdown()
      return

    # Highlight an item in the results dropdown

    select_dropdown_item = (item) ->
      if item
        if selected_dropdown_item
          deselect_dropdown_item $(selected_dropdown_item)
        item.addClass settings.classes.selectedDropdownItem
        selected_dropdown_item = item.get(0)
      return

    # Remove highlighting from an item in the results dropdown

    deselect_dropdown_item = (item) ->
      item.removeClass settings.classes.selectedDropdownItem
      selected_dropdown_item = null
      return

    # Do a search and show the "searching" dropdown if the input is longer
    # than settings.minChars

    do_search = ->
      query = input_box.val().toLowerCase()
      if query and query.length
        if selected_token
          deselect_token $(selected_token), POSITION.AFTER
        if query.length >= settings.minChars
          show_dropdown_searching()
          clearTimeout timeout
          timeout = setTimeout((->
            run_search query
            return
          ), settings.searchDelay)
        else
          hide_dropdown()
      return

    # Do the actual search

    run_search = (query) ->
      cache_key = query + computeURL()
      cached_results = cache.get(cache_key)
      if cached_results
        populate_dropdown query, cached_results
      else
        # Are we doing an ajax search or local data search?
        if settings.url
          url = computeURL()
          # Extract exisiting get params
          ajax_params = {}
          ajax_params.data = {}
          if url.indexOf('?') > -1
            parts = url.split('?')
            ajax_params.url = parts[0]
            param_array = parts[1].split('&')
            $.each param_array, (index, value) ->
              kv = value.split('=')
              ajax_params.data[kv[0]] = kv[1]
              return
          else
            ajax_params.url = url
          # Prepare the request
          ajax_params.data[settings.queryParam] = query
          ajax_params.type = settings.method
          ajax_params.dataType = settings.contentType
          if settings.crossDomain
            ajax_params.dataType = 'jsonp'
          # Attach the success callback

          ajax_params.success = (results) ->
            if $.isFunction(settings.onResult)
              results = settings.onResult.call(hidden_input, results)
            cache.add cache_key, if settings.jsonContainer then results[settings.jsonContainer] else results
            # only populate the dropdown if the results are associated with the active search query
            if input_box.val().toLowerCase() == query
              populate_dropdown query, if settings.jsonContainer then results[settings.jsonContainer] else results
            return

          # Make the request
          $.ajax ajax_params
        else if settings.local_data
          # Do the search through local data
          results = $.grep(settings.local_data, (row) ->
            row[settings.propertyToSearch].toLowerCase().indexOf(query.toLowerCase()) > -1
          )
          if $.isFunction(settings.onResult)
            results = settings.onResult.call(hidden_input, results)
          cache.add cache_key, results
          populate_dropdown query, results
      return

    # compute the dynamic URL

    computeURL = ->
      url = settings.url
      if typeof settings.url == 'function'
        url = settings.url.call()
      url

    #
    # Initialization
    #

    # Configure the data source
    if $.type(url_or_data) == 'string' or $.type(url_or_data) == 'function'
      # Set the url to query against
      settings.url = url_or_data
      # If the URL is a function, evaluate it here to do our initalization work
      url = computeURL()
      # Make a smart guess about cross-domain if it wasn't explicitly specified
      if settings.crossDomain == undefined
        if url.indexOf('://') == -1
          settings.crossDomain = false
        else
          settings.crossDomain = location.href.split(/\/+/g)[1] != url.split(/\/+/g)[1]
    else if typeof url_or_data == 'object'
      # Set the local data to search through
      settings.local_data = url_or_data
    # Build class names
    if settings.classes
      # Use custom class names
      settings.classes = $.extend({}, DEFAULT_CLASSES, settings.classes)
    else if settings.theme
      # Use theme-suffixed default class names
      settings.classes = {}
      $.each DEFAULT_CLASSES, (key, value) ->
        settings.classes[key] = value + '-' + settings.theme
        return
    else
      settings.classes = DEFAULT_CLASSES

    # Keep a reference to the original input box
    hidden_input = $(input).hide().val('').focus(->
      input_box.focus()
      return
    ).blur(->
      input_box.blur()
      return
    )

    # The list to store the token items in
    token_list = $('<ul />').addClass(settings.classes.tokenList).click((event) ->
      li = $(event.target).closest('li')
      if li and li.get(0) and $.data(li.get(0), 'tokeninput')
        toggle_select_token li
      else
        # Deselect selected token
        if selected_token
          deselect_token $(selected_token), POSITION.END
        # Focus input box
        input_box.focus()
      return
    ).mouseover((event) ->
      li = $(event.target).closest('li')
      if li and selected_token != this
        li.addClass settings.classes.highlightedToken
      return
    ).mouseout((event) ->
      li = $(event.target).closest('li')
      if li and selected_token != this
        li.removeClass settings.classes.highlightedToken
      return
    ).insertBefore(hidden_input)
    # The token holding the input box
    input_token = $('<li />').addClass(settings.classes.inputToken).appendTo(token_list).append(input_box)
    # The list to store the dropdown items in
    dropdown = $('<div>').addClass(settings.classes.dropdown).appendTo('body').hide()
    # Magic element to help us resize the text input
    input_resizer = $('<tester/>').insertAfter(input_box).css(
      position: 'absolute'
      top: -9999
      left: -9999
      width: 'auto'
      fontSize: input_box.css('fontSize')
      fontFamily: input_box.css('fontFamily')
      fontWeight: input_box.css('fontWeight')
      letterSpacing: input_box.css('letterSpacing')
      whiteSpace: 'nowrap')
    # Pre-populate list if items exist
    hidden_input.val ''
    li_data = settings.prePopulate or hidden_input.data('pre')
    if settings.processPrePopulate and $.isFunction(settings.onResult)
      li_data = settings.onResult.call(hidden_input, li_data)
    if li_data and li_data.length
      $.each li_data, (index, value) ->
        insert_token value
        checkTokenLimit()
        return
    # Initialization is done
    if $.isFunction(settings.onReady)
      settings.onReady.call()

    #
    # Public functions
    #

    @clear = ->
      token_list.children('li').each ->
        if $(this).children('input').length == 0
          delete_token $(this)
        return
      return

    @add = (item) ->
      add_token item
      return

    @remove = (item) ->
      token_list.children('li').each ->
        if $(this).children('input').length == 0
          currToken = $(this).data('tokeninput')
          match = true
          for prop of item
            if item[prop] != currToken[prop]
              match = false
              break
          if match
            delete_token $(this)
        return
      return

    @getTokens = ->
      saved_tokens

    return

  # Really basic cache for the results

  $.TokenList.Cache = (options) ->
    settings = $.extend({ max_size: 500 }, options)
    data = {}
    size = 0

    flush = ->
      data = {}
      size = 0
      return

    @add = (query, results) ->
      if size > settings.max_size
        flush()
      if !data[query]
        size += 1
      data[query] = results
      return

    @get = (query) ->
      data[query]

    return

  return
) jQuery