class window.UserChannel
  @subscribe: (uuid) =>
    App.cable.subscriptions.create { channel: "UserChannel" },
      received: @dispatch

  @dispatch: (data) =>
    console.log data
    command = Object.keys(data)[0]

    if typeof this[command] == 'function'
      this[command](data[command])
    else
      console.log "Unknown command #{command}"

  @online: (user) =>
    Materialize.toast "#{user.display_name} is online.", 3000

  @offline: (user) =>
    Materialize.toast "#{user.display_name} disconnected.", 3000
