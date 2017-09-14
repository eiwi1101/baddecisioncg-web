class @SoundEffect
  class FileNotFound extends Error

  @files:
    gameStart: 'game_start_fanfare.mp3'
    cardPlay: 'player_makes_play.mp3'

  @play: (sound) ->
    fileName = @files[sound]
    throw new FileNotFound("Sound not found: #{sound}") unless fileName

    try
      audio = new Audio('/assets/' + fileName)
      audio.play()
    catch exception
      console.warn exception
      console.warn "Are you using a really old browser, or perhaps an automated test framework, that doesn't support Audio?"
