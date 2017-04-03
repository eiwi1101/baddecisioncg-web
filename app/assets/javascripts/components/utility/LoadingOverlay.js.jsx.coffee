@LoadingOverlay = React.createClass
  propTypes:
    depth: React.PropTypes.int


  getDefaultProps: ->
    depth: 1


  render: ->
    items = if this.props.depth > 1 then 'items' else 'item'

    `<div className='loading-overlay'>
        Loading { this.props.depth } { items }...
    </div>`
