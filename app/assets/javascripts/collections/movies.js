MovieGenie.Collections.Movies = Backbone.Collection.extend({
  url: "api/movies",

  model: MovieGenie.Models.Movie,

  // localStorage: new Backbone.LocalStorage("MovieGenie"),
   
  comparator: function( collection ){
    return( -1*collection.get('predicted_rating') );
  },

  predicted_rating_comparator: function( collection ){
    return( -1*collection.get('predicted_rating') );
  },

  date_released_comparator: function( collection ){
    return( -1*(new Date(collection.get('theatre_release_date'))));
  },

  fetch: function(options) {
      return Backbone.Collection.prototype.fetch.call(this, _.extend({
          remove: false
      }, options));
  },

  getInTheatreMovies: function(){
    var filteringCriteria = function(){
      return (this.get("in_theatre"))
    } 
    return this.filterData(filteringCriteria)
  }, 

  notSeenMovies: function(){
    var filteringCriteria = function(){
      return !(this.get("listed") || this.get("rated") || this.get("notInterested"))
    } 
    return this.filterData(filteringCriteria)
  },
  
  getListedMovies: function(){
    var filteringCriteria = function(){
      return (this.get("listed"))
    } 
    return this.filterData(filteringCriteria)
  },  

  getRatedMovies: function(){
    var filteringCriteria = function(){
      return (this.get("rated"))
    } 
    return this.filterData(filteringCriteria)
  },   

  getNotInterestedMovies: function(){
    var filteringCriteria = function(){
      return (this.get("notInterested"))
    } 
    return this.filterData(filteringCriteria)
  },  
});
_.extend(MovieGenie.Collections.Movies.prototype, MovieGenie.CollectionMixIn);