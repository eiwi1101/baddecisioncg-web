@RoundHand = React.createClass
  selectCard: (guid) ->
    $.post @props.selectWinnerUrl, player_card_id: guid

  render: ->
    if @props.round
      `<div className='round-hand container margin-top-md margin-bottom-md'>
          <div dangerouslySetInnerHTML={{__html: this.props.round.story_html }} />
          <CardList>
              <Card size='s6 m3' {...this.props.round.blank_cards[0]} />
              <Card size='s6 m3' {...this.props.round.blank_cards[1]} />
              <Card size='s12 m6' {...this.props.round.blank_cards[2]} />
          </CardList>

          <CardList size='s6 m3' cards={this.props.round.player_cards} onPlay={this.selectCard} />
      </div>`

    else
      `<div></div>`
