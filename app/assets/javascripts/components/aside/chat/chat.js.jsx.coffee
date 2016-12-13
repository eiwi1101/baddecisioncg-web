@Chat = React.createClass
  getInitialState: ->
    messages: []

  componentDidMount: ->
    LobbyChannel.on 'message', (data) =>
      @setState messages: @state.messages.concat data

  render: ->
    last_user_guid = null

    messages = @state.messages.map (message) =>
      self = message.lobby_user.guid == @props.lobby_user.guid
      collapse = message.lobby_user.guid == last_user_guid
      last_user_guid = message.lobby_user.guid

      `<ChatMessage key={message.guid} message={message.message} collapse={collapse} self={self} lobby_user={message.lobby_user}/>`

    `<div id='chat' className='content'>
        <div className='system-notice'>
            Welcome to { this.props.lobby.name }
        </div>
        { messages }
    </div>`
