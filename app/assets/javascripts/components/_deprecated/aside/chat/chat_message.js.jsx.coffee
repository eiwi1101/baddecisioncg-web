@ChatMessage = (props) ->
  if props.lobby_user == undefined
    return `<div className='system-message'>deleted</div>`

  if props.lobby_user.admin
    rank_icon = `<div className='rank-icon admin'><Icon icon='star' /></div>`
  else if props.lobby_user.moderator
    rank_icon = `<div className='rank-icon moderator'><Icon icon='circle' /></div>`
  else
    rank_icon = ''

  `<div className={ 'chat-notice' + ( props.self ? ' self' : '' ) + ( props.collapse ? ' collapse' : '' ) }>
      { rank_icon }
      <img src={ props.lobby_user.avatar_url } alt={ props.lobby_user.name } />
      <div className='name'>{ props.lobby_user.name }</div>
      <div className='message'>{ props.message }</div>
  </div>`
