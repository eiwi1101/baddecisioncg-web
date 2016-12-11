@Chat = React.createClass
  getInitialState: ->
    messages: []

  componentDidMount: ->
    LobbyChannel.on 'message', (data) =>
      @setState messages: @state.messages.concat data

  render: ->
    messages = @state.messages.map (message) ->
      `<ChatMessage key={message.guid} message={message.message} lobby_user={message.lobby_user}/>`

    `<div id='chat' className='content'>
        <div className='system-notice'>
            Welcome to { this.props.lobby.name }
        </div>
        { messages }
    </div>`
