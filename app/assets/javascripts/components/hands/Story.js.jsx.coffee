@Story = React.createClass
  propTypes:
    id: React.PropTypes.string
    card: React.PropTypes.object.isRequired
    fool: React.PropTypes.object
    crisis: React.PropTypes.object
    badDecision: React.PropTypes.object


  render: ->
    # NB B NB B NB B NB

    lines = this.props.card.text.split /%\{(.*?)\}/

    blanks = lines.map (line, i) =>
      return unless line

      classNames = []
      classNames.push 'first-slot' if i == 0 or (i == 1 && !lines[0])
      classNames.push 'last-slot' if i == 6 or (i == 5 && !lines[6])

      if i & 1
        classNames.push 'blank'
        classNames.push "blank-#{Util.typeClasses[line]}"
        card = @props[Util.typeKeys[line]]

        if card
          content = card.text

        else
          content =
            `<span className='text'>{ Util.typeNames[line] }</span>`

      else
        classNames.push 'not-blank'
        content = line

      `<div key={ i } className={ classNames.join(' ') }>
          { content }
      </div>`

    `<div id={ this.props.id }>
        <div className='game-card card-story'>
            { blanks }
        </div>

        <div className='debug-data' id='story-data'>{ JSON.stringify(this.props.card) }</div>
        <div className='debug-data' id='fool-blank'>{ JSON.stringify(this.props.fool) }</div>
        <div className='debug-data' id='crisis-blank'>{ JSON.stringify(this.props.crisis) }</div>
        <div className='debug-data' id='bad-decision-blank'>{ JSON.stringify(this.props.badDecision) }</div>
    </div>`
