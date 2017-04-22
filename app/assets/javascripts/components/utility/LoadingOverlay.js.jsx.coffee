@LoadingOverlay = React.createClass
  propTypes:
    depth: React.PropTypes.number


  getDefaultProps: ->
    depth: 1


  render: ->
    items = if this.props.depth > 1 then 'items' else 'item'

    `<div className='loading-overlay'>
        <div className='loading-text'>Loading { this.props.depth } { items }...</div>
    </div>`
