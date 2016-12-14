@PlayerHand = React.createClass
  render: ->
    `<div className='bottom-panel'>
        <Tabs>
            <Tab target='#fool-hand'>Fool</Tab>
            <Tab target='#crisis-hand'>Crisis</Tab>
            <Tab target='#decision-hand'>Decision</Tab>
        </Tabs>
        { this.props.lobby_user_guid }
    </div>`


#
#.bottom-panel
#  %ul.tabs.tabs-border
#    %li.tab= link_to 'Fool Hand', '#fool-hand'
#    %li.tab= link_to 'Crisis Hand', '#crisis-hand'
#    %li.tab= link_to 'Decision Hand', '#decision-hand'
#    %li.tab= link_to 'Hide', '#hide'
#
#  #fool-hand.content
#    .row.masonry{data: { hand: 'fool' }}
#  #crisis-hand.content
#    .row.masonry{data: { hand: 'crisis' }}
#  #decision-hand.content
#    .row.masonry{data: { hand: 'bad_decision' }}
