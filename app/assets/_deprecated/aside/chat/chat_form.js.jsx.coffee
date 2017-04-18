@ChatForm = React.createClass
  handleSubmit: (e) ->
    e.preventDefault();
    $.post this.props.action, message: { message: this.refs.message.value }

  render: ->
    if this.props.signed_in
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
            <p>You must sign in or register to chat.</p>
        </div>`

    `<div className='chat-form'>
        { form_display }
    </div>`


