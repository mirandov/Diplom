# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  if $('#tasks-table').length && window.ws_url
    if window.taskController
      window.taskController.loadTasks()
    else
      window.taskController = new NewTask.Controller(window.ws_url, true)
    return

window.NewTask = {}

legal_entities = [9, 18, 29, 35, 37, 38, 39, 40, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76]

class NewTask.Controller
  template: (task, i) ->
    legal_entity = ''
    legal_entity = """<td><div class="small">#{task.legal_entity}</div></td>""" if window.user_role == 'doctor_fd'

    check        = task.legal_entity_id and (legal_entities.indexOf(task.legal_entity_id) != -1) and window.user_role == 'doctor_fd'
    red          = if check then 'text-danger' else ''
    """
    <tr id="task_#{task.id}" class="#{task.priority} #{red} tr-href" data-link="/tasks/#{task.id}" type="#{task.event_type}">
      <td><div class="big inline surname-formatted">#{task.surname}</div> <div class="inline">#{task.name}</div></td>
      #{legal_entity}
      <td><div class="small">#{task.program_name} - #{task.program_id}</div></td>
      <td><div class="small">#{task.title}</div></td>
      <td><div class="small"><div class="time-elapsed" data-sec="#{task.updated_at_sec}">-</div>#{task.updated}</div></td>
      <td><div class="owner hidden icon icon-task" data-owner="#{task.owner.id || '0'}"></div></td>
      <td class="hidden time">#{task.updated_at_sec + i}</td>
    """

  listTemplate: (tasks) ->
    i = 0
    len = tasks.length
    taskHtml = ''
    while i < len
      task = tasks[i]
      taskHtml += @template(task, i/50)
      i++

    $(taskHtml)

  constructor: (url, useWebSockets) ->
    @log 'url: ' + url
    @log 'constructor triggered'
    @dispatcher = new WebSocketRails(url, useWebSockets)
    @bindEvents()
    @dispatcher.on_open = @loadTasks  if $('#tasks-table').length

  bindEvents: =>
    @log 'bindEvents triggered'
    @dispatcher.bind 'tasks.list', @updateTaskList

    @dispatcher.bind 'task.new', (data) =>
      @log 'new channel event received: ' + data
      $('#tasks-table tbody').prepand(@template(JSON.parse(data)))
      return

    @dispatcher.bind 'task.update', (data) =>
      @log 'update channel event received: ' + data
      # $(data.html).hide().appendTo('#task_actions').fadeIn()
      return

    @dispatcher.bind 'task.delete', (data) =>
      @log 'delete channel event recieved: ' + data
      # $(data.html).hide().appendTo('#task_actions').fadeIn()
      $("#tasks-table #task_#{data.id}").remove()
      return

    return

  updateTaskList: (userList) =>
    @log "updateTaskList triggered: #{userList}"
    $('#tasks-table tbody').html @listTemplate(JSON.parse(userList))
    return

  loadTasks: =>
    @log 'loadTasks triggered'
    @dispatcher.trigger 'tasks.load'
    return

  log: (str) ->
    if console && console.log
      console.log "WebSockets:: #{str}"
    return