@UserList = React.createClass
  getInitialState: ->
    users: []

  componentDidMount: ->
    LobbyChannel.on 'user_joined', (data) =>
      @setState users: @state.users.concat data

  render: ->
    users = @state.users.map (user) ->
      `<User key={user.guid} {...user} />`
      
    `<div id='user-list' className='content'>
        <ul className='collection no-border'>
            <User key={this.props.lobby_user.guid} {...this.props.lobby_user} />
            { users }
        </ul>
    </div>`
