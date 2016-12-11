@ChatForm = React.createClass
  handleSubmit: (e) ->
    e.preventDefault();
    $.post this.props.lobby.message_url, message: { message: this.refs.message.value }

  render: ->
    if this.props.lobby_user.user?
      form_display =
        `<form onSubmit={this.handleSubmit} id='new_message'>
            <div className='input-field inline'>
                <input type='text' placeholder='Send a message...' ref='message' />
            </div>
            <button type='submit' className='btn'>
                <Icon icon='send'/>
            </button>
        </form>`

    else
      form_display =
        `<div className='grey-text center'>
            You must sign in or register to chat.
        </div>`

    `<div className='chat-form'>
        { form_display }
    </div>`


