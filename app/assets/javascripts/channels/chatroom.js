// client use


App.chatroom = App.cable.subscriptions.create("ChatroomChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {},
  speak: function(message) {
    return this.perform('speak', {
      message: message
    });
  }
});


$(document).on('submit', '.new_message', function(e) {
  e.preventDefault();
  var values = $(this).serializeArray();
  App.chatroom.speak(values);
  $(this).trigger('reset');
});