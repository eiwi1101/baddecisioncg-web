@User = React.createClass
  render: ->
    if @props.admin
      class_name = 'gold-text'
    else if @props.moderator
      class_name = 'teal-text'

    if @props.username
      username = `<div className='username smaller grey-text'>{ this.props.username }</div>`
    else
      username = `<div className='username smaller grey-text text-lighten-1'>(guest)</div>`

    `<li className='collection-item avatar'>
        <img className='circle' src={ this.props.avatar_url } alt={ this.props.name } />
        <div className={ class_name }>{ this.props.name }</div>
        { username }
    </li>`
