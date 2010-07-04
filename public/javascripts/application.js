// use to give the preview of details for an event below a calendar
var updateEventDescription = function(event, jsEvent) {
  $("#event_quick_description")[0].innerHTML = "";
  $("#event_quick_description").append(
    $("<h3/>").append(
      $('<a/>', { text : event.title, href : event.url })
    )
  );
  $("#event_quick_description")[0].innerHTML += "Location: " + event.location + "<br/>";
  $("#event_quick_description")[0].innerHTML += event.description;
  
  $("#event_quick_description").show();
}


jQuery(function($) {
  $('a.show_hide_link').attach(ShowHideLink);
});
