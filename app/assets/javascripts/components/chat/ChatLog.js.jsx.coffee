@ChatLog = React.createClass
  propTypes:
    game: React.PropTypes.object.isRequired
    lobby: React.PropTypes.object.isRequired
    messages: React.PropTypes.array


  render: ->
    `<div className='chat-log'>
        Messages: { JSON.stringify(this.props.messages) }
    </div>`
