@getLobby = (lobbyId) -> (dispatch) ->
  action = dispatch
    type: GET_LOBBY

  Model.get "/lobbies/#{lobbyId}.json", (data) -> dispatch ->
    type: LOBBY_LOADED
    data: data
  , (error) -> dispatch ->
    type: LOBBY_ERROR
    error: data
