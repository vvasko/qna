# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  PrivatePub.subscribe "/questions",(data, channel) ->
    question = $.parseJSON(data['question'])
    userSignedIn=parseInt($('#current_user').val())>0
    $('.questions_list').append(JST["question"]({question: question, user_signed_in: userSignedIn}));

  $('.edit-question-link').click (e) ->
    e.preventDefault();
    question_id = $(this).data('questionId')
    $('form#edit-question-' + question_id).show()

  $('.vote_buttons').bind 'ajax:success', (e, data, status, xhr)->
    $('.errors').html('')

    question_id = $(this).attr('id').match(/\d+/)[0]
    response = $.parseJSON(xhr.responseText)

    $('#question_' + question_id + ' .rating').html(response.rating)

    if response.user_vote != 0
      $('#vote_up_for_' + question_id).addClass('disabled')
      $('#vote_down_for_' + question_id).addClass('disabled')
      $('#vote_reset_for_' + question_id).removeClass('disabled')
    else
      $('#vote_up_for_' + question_id).removeClass('disabled')
      $('#vote_down_for_' + question_id).removeClass('disabled')
      $('#vote_reset_for_' + question_id).addClass('disabled')

  .bind 'ajax:error', (e, xhr, status, error)->
    response = $.parseJSON(xhr.responseText)
    $.each response.errors, (index, value) ->
      $('.errors').html(value)

