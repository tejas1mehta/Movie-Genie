MovieGenie.Collections.Casts = Backbone.Collection.extend({
  url: "api/casts",

  model: MovieGenie.Models.Cast

});
_.extend(MovieGenie.Collections.Casts.prototype, MovieGenie.CollectionMixIn);