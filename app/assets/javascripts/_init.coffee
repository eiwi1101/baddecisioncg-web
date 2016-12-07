# Come online and listen to global push notifications.
#
$ ->
  User.subscribe()

  # Form Hacks

  console.log Materialize
  Materialize.updateTextFields()
  $('input').change ->
    eb = $(this).parents('form > div')
    eb.removeClass('invalid')
    eb.find('.error-block').slideUp(500)

  # Side Nav

  $('.button-collapse').sideNav
    draggable: true
