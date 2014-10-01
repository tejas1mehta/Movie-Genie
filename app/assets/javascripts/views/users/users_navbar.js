MovieGenie.Views.NavBar = Backbone.CompositeView.extend({
  template: JST["users/navbar"],
  
  events: {
    "submit form": "submit"
  },

  render: function(){
    renderedContent = this.template({user: this.model});
    this.$el.html(renderedContent)
    return this
  },
  
  submit: function (event) {
    var view = this;
    event.preventDefault();

    var params = $(event.currentTarget).serializeJSON();
    var keywords = params["keywords"];
    var searchOption = params["search-options"];
    $(window).unbind("scroll")
    if (searchOption === "Movies"){
      var userSearchResults = new MovieGenie.Views.SearchResults({
        keywords: keywords
      });
      MovieGenie.currentRouter._swapView(userSearchResults)  
    } else if (searchOption === "Actors/Directors") {
      $.ajax({
        type: "GET",
        url: "/api/casts/search",
        data: {cast: {keywords: keywords}},
        success: function(response){
          var searchCollection = new MovieGenie.Collections.Casts(response);
          var userSearchResults = new MovieGenie.Views.CastSearchResults({
            collection: searchCollection,
            keywords: keywords,
            item: "cast"
          });
          MovieGenie.currentRouter._swapView(userSearchResults)           
        }
      }) 
    } else if (searchOption === "Studios") {
      $.ajax({
        type: "GET",
        url: "/api/studios/search",
        data: {studio: {keywords: keywords}},
        success: function(response){
          var searchCollection = new MovieGenie.Collections.Studios(response);
          var userSearchResults = new MovieGenie.Views.CastSearchResults({
            collection: searchCollection,
            keywords: keywords,
            item: "studio"
          });
          MovieGenie.currentRouter._swapView(userSearchResults)           
        }
      })       
    } 
  },

});