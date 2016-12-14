@PlayerHand = (props) ->
  `<div className='bottom-panel'>
      <Tabs>
          <Tab target='#fool-hand'>Fool Hand</Tab>
          <Tab target='#crisis-hand'>Crisis Hand</Tab>
          <Tab target='#decision-hand'>Decision Hand</Tab>
      </Tabs>
      { props.lobby_user_guid }
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
