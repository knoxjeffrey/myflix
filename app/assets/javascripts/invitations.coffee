# used for custom_form_for to stop email address being auto populated by browser
jQuery ->
  $invitationTokenFieldValue = $('#invitation_token').val()

  if $invitationTokenFieldValue && $invitationTokenFieldValue.length == 0
    $('.stop-autofill').val(' ')
    setTimeout( ->
      $('.stop-autofill').val('')
    , 80)