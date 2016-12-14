@RoundHand = (props) ->
  if props.round
    `<div className='round-hand container margin-top-md margin-bottom-md'>
        <div dangerouslySetInnerHTML={{__html: props.round.story_html }} />
        <div className='row'>
            <div className='col s6 m3' dangerouslySetInnerHTML={{__html: props.round.blank_cards[0].html }} />
            <div className='col s6 m3'>{ props.round.blank_cards[1].html }</div>
            <div className='col s12 m6'>{ props.round.blank_cards[2].html }</div>
        </div>
    </div>`

  else
    `<div></div>`
