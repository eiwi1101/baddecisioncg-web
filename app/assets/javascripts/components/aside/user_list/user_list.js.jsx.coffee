@UserList = React.createClass
  getInitialState: ->
    users: @props.users

  componentDidMount: ->
    LobbyChannel.on 'user_joined', (user) =>
      @setState users: @state.users.concat user

    LobbyChannel.on 'user_leave', (user) =>
      @setState users: @state.users.filter (el) ->
        el.guid != user.guid

  render: ->
    users = @state.users.map (user) =>
      self = user.guid == @props.lobby_user.guid
      `<User key={user.guid} self={self} {...user} />`
      
    `<div id='user-list' className='content'>
        { users }
    </div>`
