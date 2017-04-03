@Card = React.createClass
  doPlay: (e) ->
    e.preventDefault()
    if @props.onPlay
      @props.onPlay(@props.guid)

  render: ->
    @props.size = 's12' unless @props.size
    className = "col #{@props.size}"
    cardClassName = "game-card #{@props.type}"

    if @props.guid
      `<div className={className}>
          <a className={cardClassName} href='#' onClick={this.doPlay}>
              <div className='card-content'>
                  { this.props.text }
              </div>
          </a>
      </div>`
    else
      `<div />`
