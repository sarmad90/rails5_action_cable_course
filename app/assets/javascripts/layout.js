var Layout;

Layout = (function() {
  function Layout() {}

  Layout.pauseLoadingOverlay = function () {
    window.pauseLoadingOverlay = true;

    $(document).ajaxComplete(function() {
      window.pauseLoadingOverlay = false;
    });
  };

  Layout.showBootstrapNotifications = function (title, message, type) {
    if(!type) {
      type = 'success'
    }

    $.notify({
      title: title,
      message: message
    },{
      // settings
      type: type
    });
  };

  Layout.prototype.slideUpFlashMessages = function() {
    window.setTimeout((function() {
      return $('.flash-messages').fadeTo(500, 0).slideUp(500, function() {
        return $(this).hide();
      });
    }), 5000);
  };

  return Layout;
})();

$(document).on("turbolinks:load", function() {
  var layout = new Layout();
  layout.slideUpFlashMessages();
});
