window.MovieGenie = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},

  addAlert: function(alertText){
    var $alertDiv = $("<div class='alert alert-dismissable alert-danger'> <button type='button' class='close' data-dismiss='alert'>×</button><div class='alert-text'></div></div>")    
    $alertDiv.find("div.alert-text").html(alertText)
    $(".alert-data").append($alertDiv)
  },

  otherTabData: function(){
    updatedCollection = new MovieGenie.Collections.Movies(JSON.parse( localStorage.getItem( 'all_movies' ))) ;
    updatedCollection.forEach(function(updatedModel){
      var updatedModelId = updatedModel.id
      var previousModel = MovieGenie.allMovies.get(updatedModelId)
      if (updatedModel.attributes !== previousModel.attributes){
        previousModel.set(updatedModel.attributes)
      }
    })
  },
  
  initialize: function() {
    MovieGenie.currentRouter = new MovieGenie.Routers.Users({
      $rootEl: $("div#content"),
      $navbar: $("div#navbar")
    });

    MovieGenie.url = "" //"movie-genie.herokuapp.com/"
    MovieGenie.assetsUrl = MovieGenie.url + "assets/";
    MovieGenie.loadingGenie = "<img class='movie-image img-responsive' src='" + MovieGenie.assetsUrl + "Loading_genie.gif'>"
    MovieGenie.resultsPerPage = 20

    var oriHash = window.location.hash
    if (!Backbone.History.started){
      Backbone.history.start();
    } else {
      Backbone.history.navigate("")
    }

    Backbone.history.navigate(oriHash, { trigger: true })
  },

  setSessionModels: function(response){
    if (!localStorage.getItem( 'all_movies' )){
      Backbone.history.navigate("#", { trigger: true })
    }

    MovieGenie.allMovies = new MovieGenie.Collections.Movies(JSON.parse( localStorage.getItem( 'all_movies' ))) ;
    MovieGenie.allGenres = new MovieGenie.Collections.Genres();
    MovieGenie.allCasts =  new MovieGenie.Collections.Casts();
    MovieGenie.allStudios = new MovieGenie.Collections.Studios();
    
    if (response.all_genres){
      MovieGenie.allGenres.add(response.all_genres, {merge: true});
      delete response.allGenres
    }

    MovieGenie.navbarView = new MovieGenie.Views.NavBar({
      model: MovieGenie.currentUser
    });
    $("#navbar").html(MovieGenie.navbarView.render().$el)      
  },

  createSession: function(response){
    MovieGenie.allMovies = new MovieGenie.Collections.Movies();
    MovieGenie.allGenres = new MovieGenie.Collections.Genres();
    MovieGenie.allCasts =  new MovieGenie.Collections.Casts();
    MovieGenie.allStudios = new MovieGenie.Collections.Studios();

    if (response.id){
      MovieGenie.currentUser.set("id", response.id);
      delete response.id
    }

    if (response.genres_saved || response.genres_saved === false){
      MovieGenie.currentUser.set("genres_saved", response.genres_saved);
      delete response.genres_saved
    }

    if (response.name){
      MovieGenie.currentUser.set("name", response.name);
      delete response.name
    }

    if (response.all_movies){
      MovieGenie.allMovies.add(response.all_movies, {merge: true});
      delete response.all_movies
    }

    if (response.all_genres){
      MovieGenie.allGenres.add(response.all_genres, {merge: true});
      delete response.allGenres
    }

    if (response.listed_movie_joins){
      response.listed_movie_joins.forEach(function(listedMovie){
        var movie = MovieGenie.allMovies.get(listedMovie.movie_id)
        movie.set({listed: true, listed_join_id: listedMovie.id});
      })
      delete response.listed_movies
    }

    if (response.not_interested_movie_joins){
      response.not_interested_movie_joins.forEach(function(notInterestedMovie){
        var movie = MovieGenie.allMovies.get(notInterestedMovie.movie_id)
        movie.set({notInterested: true, not_interested_join_id: notInterestedMovie.id});
      })
      delete response.not_interested_movie_joins
    }    

    if (response.rated_movie_joins){
      response.rated_movie_joins.forEach(function(ratedMovie){
        var movie = MovieGenie.allMovies.get(ratedMovie.movie_id)
        movie.set({rated: true, rating: ratedMovie.movie_rating, rated_join_id: ratedMovie.id});
      })
      delete response.rated_movies
    }

    localStorage.setItem( 'all_movies', JSON.stringify(MovieGenie.allMovies) );

    MovieGenie.navbarView = new MovieGenie.Views.NavBar({
      model: MovieGenie.currentUser
    });
    $("#navbar").html(MovieGenie.navbarView.render().$el)    
  },  
};

// $(document).ready(function(){
//   MovieGenie.initialize();
// });

Backbone.CompositeView = Backbone.View.extend({
  addSubview: function (selector, subview) {
    this.subviews(selector).push(subview);
    // Try to attach the subview. Render it as a convenience.
    this.attachSubview(selector, subview.render());
  },

  attachSubview: function (selector, subview, prepend) {
    if (prepend){
      this.$(selector).prepend(subview.$el);
    } else {
      this.$(selector).append(subview.$el);
    }
    // Bind events in case `subview` has previously been removed from
    // DOM.
    subview.delegateEvents();
    if (subview.attachSubviews) {
      subview.attachSubviews();
    }
  },

  attachSubviews: function () {
    var view = this;
    _(this.subviews()).each(function (subviews, selector) {
      view.$(selector).empty();
      _(subviews).each(function (subview) {
        view.attachSubview(selector, subview);
      });
    });
  },

  remove: function () {
    if (this.filCols){
      this.filCols.forEach(function(filCol){
        filCol.trigger("unbind")
      })
    }
    Backbone.View.prototype.remove.call(this);
    _(this.subviews()).each(function (subviews) {
      _(subviews).each(function (subview) { subview.remove(); });
    });
  },

  removeSubview: function (selector, subview) {
    subview.remove();

    var subviews = this.subviews(selector);
    subviews.splice(subviews.indexOf(subview), 1);
  },

  removeAllSubviews: function(selector){
    var view = this;
    var selectorSubviews = this.subviews(selector);
    var i = 0;
    var lengthSubviews = selectorSubviews.length
    while (i < lengthSubviews){
      i += 1;
      subview = selectorSubviews["0"];
      view.removeSubview(selector, subview)
    }
  },

  subviews: function (selector) {
    // Map of selectors to subviews that live inside that selector.
    // Optionally pass a selector and I'll initialize/return an array
    // of subviews for the sel.
    this._subviews = this._subviews || {};

    if (!selector) {
      return this._subviews;
    } else {
      this._subviews[selector] = this._subviews[selector] || [];
      return this._subviews[selector];
    }
  }
});

var originalRoute = Backbone.Router.prototype.route;

var nop = function(){};

_.extend(Backbone.Router.prototype, {

  // Add default before filter.
  before: nop,

  // Add default after filter.
  after: nop,

  route: function(route, name, callback) {

    if( !callback ){
      callback = this[ name ];
    }
    var executeFn

    var wrappedCallback = _.bind( function() {

      var callbackArgs = [ route, _.toArray(arguments) ];
      var beforeCallback;

      if ( _.isFunction(this.before) ) {

        beforeCallback = this.before;
      } else if ( typeof this.before[route] !== "undefined" ) {

        beforeCallback = this.before[route];
      } else {

        beforeCallback = nop;
      }

      executeFn = beforeCallback.apply(this, callbackArgs);

      if( callback ) {
        callback.apply( this, arguments );
      }

      var afterCallback;
      if ( _.isFunction(this.after) ) {

        afterCallback = this.after;

      } else if ( typeof this.after[route] !== "undefined" ) {

        afterCallback = this.after[route];

      } else {

        afterCallback = nop;
      }

      afterCallback.apply( this, callbackArgs );

    }, this);

    if (executeFn !== false){
      return originalRoute.call( this, route, name, wrappedCallback );
    }
  }

});