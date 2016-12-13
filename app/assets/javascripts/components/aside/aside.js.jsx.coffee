@Aside = React.createClass
  render: ->
    `<aside>
        <AsideTabs/>

        <Chat lobby={this.props.lobby} users={this.props.users} messages={this.props.messages} lobby_user_id={this.props.lobby_user_id} />
        <UserList lobby_user_id={this.props.lobby_user_id} users={this.props.users} />
        <Settings lobby={this.props.lobby} />

        <ChatForm action={this.props.lobby.new_message_url} signed_in={this.props.signed_in} />
    </aside>`
