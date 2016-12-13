@Aside = React.createClass
  render: ->
    `<aside>
        <AsideTabs/>

        <Chat lobby={this.props.lobby} lobby_user={this.props.lobby_user} />
        <UserList lobby_user={this.props.lobby_user} users={this.props.lobby.lobby_users} />
        <Settings lobby={this.props.lobby} />

        <ChatForm action={this.props.lobby.new_message_url} signed_in={this.props.lobby_user.user != undefined} />
    </aside>`
