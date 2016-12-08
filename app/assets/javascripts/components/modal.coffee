#Override the default confirm dialog by rails
if false
  $.rails.allowAction = (link) ->
    if link.data('confirm') == undefined
      return true
    $.rails.showConfirmationDialog link
    false

  #User click confirm button

  $.rails.confirmed = (link) ->
    link.data 'confirm', null
    link.trigger 'click.rails'

  #Display the confirmation dialog

  $.rails.showConfirmationDialog = (link) ->
    message = link.data('confirm')

    $.fn.SimpleModal(
      model: 'modal'
      title: 'Please confirm'
      contents: message).addButton('Confirm', 'button alert', ->
        $.rails.confirmed link
        @hideModal()
    ).addButton('Cancel', 'button secondary').showModal()
