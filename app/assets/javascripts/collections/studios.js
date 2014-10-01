MovieGenie.Collections.Studios = Backbone.Collection.extend({
  url: "api/studios",

  model: MovieGenie.Models.Studio

});
_.extend(MovieGenie.Collections.Studios.prototype, MovieGenie.CollectionMixIn);