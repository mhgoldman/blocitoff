// namespace to minimize polluting global scope and name-collision risk
var blocitoff = { api: {} };

(function() {
  function initApiDefaults() {

    var apiTokenElement = $("meta[name=api_token]")
    var apiAvailable = apiTokenElement.length > 0;

    if (!apiAvailable) return;

    var defaults = {
      dataType: "json", contentType: "application/json; charset=utf-8",
      headers: {
        "X-User-Email": $("meta[name=api_email]").attr('content'),
        "X-User-Token": apiTokenElement.attr('content')
      }
    };

    blocitoff.api.buildOptions = function(extraOptions) {
      // The first arg to extend is a new blank Object to avoid modifying defaults.
      var options = jQuery.extend({}, defaults, extraOptions);
      return options;
    }

  };

  $(document).on("page:change", initApiDefaults);
})();
