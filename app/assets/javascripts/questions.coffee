# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    question_id = $(this).data('questionId')
    console.log($('form#edit-question-' + question_id))
    $('form#edit-question-' + question_id).show()

  $('.vote_buttons').bind 'ajax:success', (e, data, status, xhr)->
    $('.errors').html('')

    question_id = $(this).attr('id').match(/\d+/)[0]
    response = $.parseJSON(xhr.responseText)

    $('#question_' + question_id + ' .rating').html(response.rating)
    $('#question_' + question_id + ' .user_vote').html(response.user_vote)

    if response.user_vote != 0
      $('#vote_up_for_' + question_id).addClass('disabled')
      $('#vote_down_for_' + question_id).addClass('disabled')
      $('#vote_reset_for_' + question_id).removeClass('disabled')
    else
      $('#vote_up_for_' + question_id).removeClass('disabled')
      $('#vote_down_for_' + question_id).removeClass('disabled')
      $('#vote_reset_for_' + question_id).addClass('disabled')

  .bind 'ajax:error', (e, xhr, status, error)->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.errors').html(value)
