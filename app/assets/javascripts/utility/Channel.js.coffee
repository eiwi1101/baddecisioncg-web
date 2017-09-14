class window.Channel
  channel: null
  callbacks: null
  connection: null

  constructor: (@channel) ->
    window.AppConsumer ||= ActionCable.createConsumer()
    @callbacks = {}

  subscribe: (data, callbacks={}) =>
    data.channel = @channel

    @connection = AppConsumer.subscriptions.create data,
      received: @dispatch
      connected: @connected
      disconnected: @disconnected
      rejected: @rejected

    for action, callback of callbacks
      @on action, callback

    console.log "[Action Cable] Subscribing to #{@channel}"

  perform: (command, args=null) =>
    @connection.perform(command, args)
      
  disconnected: =>
    console.debug "[Action Cable] Disconnected from #{@channel}"
    @dispatch disconnect: null

  connected: =>
    console.debug "[Action Cable] Connected to #{@channel}"
    @dispatch connect: null

  rejected: =>
    console.debug "[Action Cable] Rejected from #{@channel}"
    @dispatch reject: null

  dispatch: (data) =>
    console.debug "[Action Cable] #{@channel} got #{JSON.stringify(data)}"
    command = Object.keys(data)[0]

    if @callbacks[command]
      $.each @callbacks[command], (index, callback) ->
        callback(data[command])

  on: (command, callback) =>
    @callbacks[command] = [] unless @callbacks[command] != undefined
    @callbacks[command].push callback
    @
