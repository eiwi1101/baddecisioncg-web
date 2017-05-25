{
  GET_LOBBY
  UPDATE_LOBBY
  LOBBY_LOADED
  LOBBY_ERROR
} = require '../constants.coffee'

Immutable = require 'immutable'

LobbyReducer = (state, action) ->
  initialState =
    lobby: null
    currentUser: null
    users: null
    isLoading: 1
    error: null

  state = if state then state else initialState
  state = Immutable.fromJS state

  switch action.type
    when GET_LOBBY
      state = state.merge
        isLoading: 1

    when LOBBY_LOADED
      state = state.merge
        isLoading: 0
        lobby: action.payload

    when LOBBY_ERROR
      state = state.merge
        isLoading: 0
        error: action.error

  return state.toJS()

module.exports = LobbyReducer
