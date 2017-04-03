@AsideTabs = React.createClass
  componentDidMount: =>
    $('ul.tabs').tabs()

  render: ->
    `<div className='row no-margin'>
      <ul className='tabs tabs-border'>
        <li className='tab col s4'><a href='#chat'><Icon icon='chat'/></a></li>
        <li className='tab col s4'><a href='#user-list'><Icon icon='supervisor_account'/></a></li>
        <li className='tab col s4'><a href='#settings'><Icon icon='settings'/></a></li>
      </ul>
    </div>`
