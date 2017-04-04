@Error = React.createClass
  propTypes:
    error: React.PropTypes.string


  render: ->
    `<div className='error'>
        { this.props.error || 'Something went wrong.' }
        <a href='/l'>Return to Lobby List</a>
    </div>`
