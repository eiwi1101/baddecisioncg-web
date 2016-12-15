@Card = (props) ->
  props.size = 's12' unless props.size
  className = 'col ' + props.size

  `<div className={className}>{ JSON.stringify(props) }</div>`
