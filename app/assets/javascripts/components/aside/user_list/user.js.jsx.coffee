@User = React.createClass
  render: ->
    if @props.admin
      class_name = 'gold-text'
      rank_icon = `<div className='rank-icon admin'><Icon icon='star' /></div>`
    else if @props.moderator
      class_name = 'teal-text'
      rank_icon = `<div className='rank-icon moderator'><Icon icon='circle' /></div>`
    else
      rank_icon = ''

    if @props.username
      username = `<div className='message grey-text'>{ this.props.username }</div>`
    else
      username = `<div className='message grey-text text-lighten-1'>(guest)</div>`

    `<div className={ 'chat-notice ' + ( this.props.self ? 'self ' : '' ) + class_name }>
        { rank_icon }
        <img src={ this.props.avatar_url } alt={ this.props.name } />
        <div className='name'>{ this.props.name }</div>
        { username }
    </div>`
