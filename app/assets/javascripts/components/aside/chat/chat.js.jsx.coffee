@Chat = React.createClass
  render: ->
    last_user_guid = null
    
    messages = @props.messages.map (message) =>
      self = message.lobby_user_guid == @props.lobby_user_id
      collapse = message.lobby_user_guid == last_user_guid
      last_user_guid = message.lobby_user_guid
      lobby_user = @props.users[message.lobby_user_guid]

      `<ChatMessage key={message.guid} message={message.message} collapse={collapse} self={self} lobby_user={lobby_user}/>`

    if @props.messages.length == 0
      welcome =
        `<div className='system-notice'>
          Welcome to { this.props.lobby.name }
        </div>`

    `<div id='chat' className='content'>
        { welcome }
        { messages }
    </div>`
