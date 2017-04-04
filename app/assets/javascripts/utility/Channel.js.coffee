class window.Channel
  channel: null
  callbacks: {}
  connection: null

  constructor: (@channel) ->
    window.AppConsumer ||= ActionCable.createConsumer()

  subscribe: (data, callbacks={}) =>
    data.channel = @channel

    @connection = AppConsumer.subscriptions.create data,
      received: @dispatch
      connected: @connected
      disconnected: @disconnected
      rejected: @rejected

    for action, callback of callbacks
      @on action, callback

  perform: (command, args=null) =>
    @connection.perform(command, args)
      
  disconnected: =>
    console.log "Disconnected from #{@channel}"
    @dispatch disconnect: null

  connected: =>
    console.log "Connected to #{@channel}"
    @dispatch connect: null

  rejected: =>
    console.log "Rejected from #{@channel}"
    @dispatch reject: null

  dispatch: (data) =>
    console.log "#{@channel} got ", data
    command = Object.keys(data)[0]

    if @callbacks[command]
      $.each @callbacks[command], (index, callback) ->
        callback(data[command])

  on: (command, callback) =>
    console.log "#{@channel}.on #{command}"
    @callbacks[command] = [] unless @callbacks[command] != undefined
    @callbacks[command].push callback
