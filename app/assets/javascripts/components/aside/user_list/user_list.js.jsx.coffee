@UserList = React.createClass
  render: ->
    users = []

    for key, user of @props.users
      self = user.guid == @props.lobby_user_id
      users.push `<User key={key} self={self} {...user} />`
      
    `<div id='user-list' className='content'>
        { users }
    </div>`
