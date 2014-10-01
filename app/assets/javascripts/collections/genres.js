MovieGenie.Collections.Genres = Backbone.Collection.extend({
  url: "api/genres",

  model: MovieGenie.Models.Genre,

  parse: function (response) {
    MovieGenie.allGenres.add(response,{merge: true, parse: false});
    delete response;
  },

  fetch: function(options) {
      return Backbone.Collection.prototype.fetch.call(this, _.extend({
          remove: false, merge: true
      }, options));
  },    

});
_.extend(MovieGenie.Collections.Genres.prototype, MovieGenie.CollectionMixIn);