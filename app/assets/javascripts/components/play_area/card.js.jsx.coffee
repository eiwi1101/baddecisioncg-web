@Card = (props) ->
  props.size = 's12' unless props.size
  className = "col #{props.size}"
  cardClassName = "game-card #{props.type}"

  `<div className={className}>
      <div className={cardClassName}>
          <div className='card-content'>
              { props.text }
          </div>
      </div>
  </div>`
