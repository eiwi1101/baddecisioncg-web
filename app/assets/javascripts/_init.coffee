# Come online and listen to global push notifications.
#
$(document).ready ->
  console.log 'running init script'

  User.subscribe()

  # Form Hacks
  Materialize.updateTextFields && Materialize.updateTextFields()

  $('input').change ->
    eb = $(this).parents('form > div')
    eb.removeClass('invalid')
    eb.find('.error-block').slideUp(500)

  $('select').material_select()

  # Side Nav
  $('.button-collapse').sideNav
    draggable: true

  # Masonry Things
  if $masonry = $('.masonry')
    $masonry.masonry
      itemSelectory: '.col'
      columnWidth: '.col:first-child'
      percentPosition: true

$(document).on 'turbolinks:visit', ->
  console.log 'visit'

$(document).on 'turbolinks:render', ->
  console.log 'render'

$(document).on 'turbolinks:load', ->
  console.log 'load'

$.turbo.use 'turbolinks:load'
