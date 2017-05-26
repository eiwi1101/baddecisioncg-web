@ChatLog = React.createClass
  propTypes:
    lobby: React.PropTypes.object.isRequired
    users: React.PropTypes.array.isRequired
    messages: React.PropTypes.array

  _getCmpRank: (p) ->
    switch
      when p.is_deleted then 99
      when p.admin then 0
      when p.moderator then 1
      else 2

  _userSort: (a, b) ->
    x = @_getCmpRank a
    y = @_getCmpRank b
    x - y


  render: ->
    users = this.props.users.sort(@_userSort).map (user) ->
      classNames = ['chat-user']
      classNames.push 'spectator' unless user.in_game

      if user.admin
        classNames.push 'admin'
        rank = 'star'

      if user.moderator
        classNames.push 'moderator'
        rank = 'security'

      if user.is_deleted
        classNames.push 'offline'

      `<div className={ classNames.join(' ') } key={ user.id }>
          <div className='debug-data'>{ JSON.stringify(user) }</div>

          { rank && <div className='rank'><i className='material-icons'>{ rank }</i></div> }
          <img src={ user.avatar_url } alt={ user.name } className='avatar' />

          <div className='user-data'>
              <div className='name'>{ user.name }</div>
              <div className={ 'username' + (user.username == '' ? ' guest' : '') }>{ user.username || 'Guest' }</div>
          </div>
      </div>`

    `<div className='chat-log'>
        <div className='chat-contents user-list' id='user-list'>
            { users }
        </div>

        <div className='chat-contents' id='message-list'>
            { JSON.stringify(this.props.messages) }
        </div>
    </div>`
