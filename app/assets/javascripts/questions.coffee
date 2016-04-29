# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    question_id = $(this).data('questionId')
    console.log($('form#edit-question-' + question_id))
    $('form#edit-question-' + question_id).show()


