MovieGenie.Models.User = Backbone.Model.extend({
  urlRoot: "/api/users",
  parse: function (response) {
    MovieGenie.createSession(response)
    delete response
  },

});
