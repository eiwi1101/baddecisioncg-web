@ChatMessage = React.createClass
  render: ->
    if this.props.lobby_user.admin
      rank_icon = `<div className='rank-icon admin'><Icon icon='star' /></div>`
    else if this.props.lobby_user.moderator
      rank_icon = `<div className='rank-icon moderator'><Icon icon='circle' /></div>`
    else
      rank_icon = ''

    `<div className={ 'chat-notice' + ( this.props.self ? ' self' : '' ) + ( this.props.collapse ? ' collapse' : '' ) }>
        { rank_icon }
        <img src={ this.props.lobby_user.avatar_url } alt={ this.props.lobby_user.name } />
        <div className='name'>{ this.props.lobby_user.name }</div>
        <div className='message'>{ this.props.message }</div>
    </div>`
