# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.add-comment').click (e) ->
    e.preventDefault()
    $(this).hide()
    form_id=$(this).data('formId')
    $('form#'+form_id).show();