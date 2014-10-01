MovieGenie.Models.Session = Backbone.Model.extend({
  urlRoot: "/api/session",
  parse: function (response) {
    MovieGenie.createSession(response)
    delete response
  },
});
