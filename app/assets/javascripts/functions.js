$(function() {
  $("form").submit(function(event) {
    event.preventDefault();
    var q = $("#search_q").val();
    if (q == "") 
      return false;

    $.getJSON("/definitions", { q: q }, function(json) {
      $("#flash").empty().hide();
      if (json.notfound == true) {
        $("#flash").prepend("Failed to find a definition for " + q).show('slow');
      }
      else {
        $("#definition_results").prepend("<li class='hidden'>" + 
                                        "<dl>" +
                                        "<dt>" + json.title + "</dt>" + 
                                        "<dd>" + json.definition + "</dd>" + 
                                        "</dl>" +
                                        "</li>");
        $("li.hidden").show('slow');
      }
    });

    return false;
  });
});

