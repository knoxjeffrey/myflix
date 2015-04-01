# used for custom_form_for to stop email address being auto populated by browser but prevents this if there is an invitation token because I want this to be populated
jQuery ->
  $invitationTokenFieldValue = $('#invitation_token').val()

  if $invitationTokenFieldValue and $invitationTokenFieldValue.length == 0
    $('.stop-autofill').val(' ')
    setTimeout( ->
      $('.stop-autofill').val('')
    , 80)