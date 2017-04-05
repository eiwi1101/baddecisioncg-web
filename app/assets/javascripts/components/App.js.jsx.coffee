@App = React.createClass
  propTypes:
    lobbyId: React.PropTypes.string.isRequired
    currentUserId: React.PropTypes.string.isRequired

  childContextTypes:
    currentUser: React.PropTypes.object


  getInitialState: ->
    lobby: null
    currentUser: null
    users: null
    isLoading: 0
    error: null

  getChildContext: ->
    currentUser: @state.currentUser


  componentWillMount: ->
    @_getLobby(@props.lobbyId)
    @_getCurrentUser(@props.currentUserId)

    $(document)
      .on 'app:loading', (e) =>
        @_loadStart()

      .on 'app:loading:stop', (e) =>
        @_loadStop()

    $(window)
      .unload =>
        @_deleteCurrentUser(@props.currentUserId)

    LobbyChannel.subscribe { lobbyId: @props.lobbyId, userId: @props.currentUserId },
      user: (u) =>
        users = $.grep @state.users, (i) ->
          i.id != u.id
        users.push u

        if u.is_deleted
          $(document).trigger 'app:user:leave', u
          Materialize.toast "#{u.name} has left.", 3000, 'blue-grey'
        else if users.length == @state.users.length
          $(document).trigger 'app:user:update', u
        else
          $(document).trigger 'app:user:join', u
          Materialize.toast "#{u.name} has joined the lobby.", 3000, 'blue-grey'

        @setState users: users


  componentWillUnmount: ->
    @_deleteCurrentUser(@props.currentUserId)

    $(document)
      .off 'app:loading'
      .off 'app:loading:stop'

  _getLobby: (lobbyId) ->
    Model.fetch "/l/#{lobbyId}.json", (data) =>
      @setState lobby: data.lobby, users: data.lobby?.users
    , (error) =>
      @setState error: error.error

  _getCurrentUser: (currentUserId) ->
    Model.fetch "/lobby_users/#{currentUserId}.json", (data) =>
      @setState currentUser: data

  _deleteCurrentUser: (currentUserId) ->
    Model.delete "/lobby_users/#{currentUserId}.json"


  _loadStart: (updateState=true) ->
    level = @state.isLoading + 1
    level = 1 if level <= 0
    @setState isLoading: level

  _loadStop: (updateState=true) ->
    level = @state.isLoading - 1
    level = 0 if level < 0
    @setState isLoading: level


  _onlineUsers: ->
    if @state.users
      u = $.grep @state.users, (u) ->
        !u.is_deleted


  render: ->
    if @state.error?
      return `<Error error={ this.state.error } />`

    if @state.isLoading > 0
      loading =
        `<LoadingOverlay depth={ this.state.isLoading } />`

    if @state.lobby? and @state.currentUser?
      game =
        `<Game lobby={ this.state.lobby }
               currentUser={ this.state.currentUser }
               game={ this.state.lobby.current_game }>

            <ChatLog lobby={ this.state.lobby }
                     messages={ this.state.lobby.messages } />

            <PlayerHands currentUser={ this.state.currentUser }
                         cards={ this.state.currentUser.cards } />
        </Game>`

    `<div id='app-main'>
        { loading }

        <div id='lobby-data'>Lobby: { JSON.stringify(this.state.lobby) }</div>
        <div id='current-user'>Current User: { JSON.stringify(this.state.currentUser) }</div>
        <div id='lobby-users'>Users: { JSON.stringify(this._onlineUsers()) }</div>

        { game }
    </div>`
