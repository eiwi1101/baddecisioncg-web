@App = React.createClass
  propTypes:
    lobbyId: React.PropTypes.string.isRequired
    currentUserId: React.PropTypes.string.isRequired

  childContextTypes:
    currentUser: React.PropTypes.object


  getInitialState: ->
    lobby: null
    currentUser: null
    isLoading: 0

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

  componentWillUnmount: ->
    $(document)
      .off 'app:loading'
      .off 'app:loading:stop'

  _getLobby: (lobbyId) ->
    Model.fetch "/l/#{lobbyId}.json", (data) =>
      @setState lobby: data.lobby

  _getCurrentUser: (currentUserId) ->
    Model.fetch "/lobby_users/#{currentUserId}.json", (data) =>
      @setState currentUser: data


  _loadStart: (updateState=true) ->
    level = @state.isLoading + 1
    level = 1 if level <= 0
    @setState isLoading: level

  _loadStop: (updateState=true) ->
    level = @state.isLoading - 1
    level = 0 if level < 0
    @setState isLoading: level


  render: ->
    if this.state.isLoading > 0
      loading =
        `<LoadingOverlay depth={ this.state.isLoading } />`

    if this.state.lobby? and this.state.currentUser?
      game =
        `<Game lobby={ this.state.lobby }
               game={ this.state.lobby.current_game }>

            <ChatLog lobby={ this.state.lobby }
                     messages={ this.state.lobby.messages } />

            <PlayerHands currentUser={ this.state.currentUser }
                         cards={ this.state.currentUser.cards } />
        </Game>`

    `<div id='app-main'>
        { loading }

        <div>Lobby: { JSON.stringify(this.state.lobby) }</div>
        <div>Current User: { JSON.stringify(this.state.currentUser) }</div>

        { game }
    </div>`
