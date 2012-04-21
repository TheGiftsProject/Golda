chrome.extension.onRequest.addListener(function(request, sender, sendResponse) {
    if (request.action == "getDOM") {
        sendResponse({dom: document.body.innerHTML});
    } else if (request.action == "getDetails") {
        $.ajax("/isracard/amex", { data: request.postParams, type: "POST", success: function(response) {
            sendResponse( { dom: response } );
        }});
    } else if (request.action == "startModalAction"){
        var modal = $("<div>", { 'class': 'top_modal_thing' });
        modal.css('position', 'absolute');
        modal.css('left','0');
        modal.css('top','0');
        modal.css('background-color', '#000000');
        modal.css('opacity', '0.3');
        modal.css('width', $(document).width());
        modal.css('height', $(document).height());
        modal.css('z-index', 100000);
        modal.appendTo($("body"));

        var progressBar = $("<div>", { 'class': 'golda_progress_container' });
        progressBar.css('position', 'fixed');
        progressBar.css('left', $(document).width()/2 - 100);
        progressBar.css('top', 300);
        progressBar.css('background-color', '#FFFFFF');
        progressBar.css('width', 200);
        progressBar.css('height', 50);
        progressBar.css('z-index', '100001');
        progressBar.appendTo(modal);

        var progressIndicator = $("<div>", { 'class': 'golda_progress_indicator' });
        progressIndicator.css('width', '0');
        progressIndicator.css('height', '50');
        progressIndicator.css('background-color', '#FF0000');
        progressIndicator.appendTo(progressBar);

    } else if (request.action == "endModalAction"){
        $(".top_modal_thing").remove();
    } else if (request.action == "updateProgress") {
        $(".golda_progress_indicator").width(200 * request.progress);
    } else {
        sendResponse({}); // Send nothing..
    }
});

