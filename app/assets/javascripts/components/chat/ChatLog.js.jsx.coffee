@ChatLog = React.createClass
  propTypes:
    lobby: React.PropTypes.object.isRequired
    messages: React.PropTypes.array


  render: ->
    `<div className='chat-log'>
        Messages: { JSON.stringify(this.props.messages) }
    </div>`
