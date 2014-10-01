MovieGenie.Views.MoviesMiniView = Backbone.View.extend({

  template: JST['movies/miniview'],
  tagName: "div class='col-xs-3' style='text-align: center; height:450px'",
  initialize: function(){
    this.listenTo(this.model, "change", this.render);
  },
  events: {
    "click .rating-container" : "rateMovie",
    "submit form#listMovie" : "listMovie",
    "submit form#unlistMovie" : "unlistMovie",   
    "submit form#notInterestedMovie" : "noInterestMovie",
    "submit form#interestedMovie" : "interestMovie",        
  },     

  changeStore: function(){
    localStorage.setItem( 'all_movies', JSON.stringify(MovieGenie.allMovies));
  },

  noInterestMovie: function(event){
    event.preventDefault()
    var view = this;
    $.ajax({
      type: "POST",
      url: "/api/user_not_interested_joins/",
      data: {user_not_interested_join: {movie_id: this.model.id}},
      success: function(response){
        view.model.set("not_interested_join_id", response.id)
        view.model.set("notInterested", true)        
        view.changeStore()
      }
    })   
  },

  interestMovie: function(event){
    event.preventDefault()
    var view = this;
    $.ajax({
      type: "DELETE",
      url: "/api/user_not_interested_joins/" + this.model.get("not_interested_join_id"),
      success: function(){
        view.model.set("notInterested", false)        
        view.changeStore()
      }
    })   
  },

  listMovie: function(event){
    event.preventDefault()
    var view = this;
    $.ajax({
      type: "POST",
      url: "/api/user_list_joins/",
      data: {user_list_join: {movie_id: this.model.id}},
      success: function(response){
        view.model.set("listed_join_id", response.id)
        view.model.set("listed", true)        
        view.changeStore()
      }
    })   
  },

  unlistMovie: function(event){
    event.preventDefault()
    var view = this;
    $.ajax({
      type: "DELETE",
      url: "/api/user_list_joins/" + this.model.get("listed_join_id"),
      success: function(){
        view.model.set("listed", false)        
        view.changeStore()
      }
    })   
  },

  rateMovie: function(event){
    var clickPosn = event.pageX;
    var stars = this.$(".rating-container")
    var elPosn = stars.offset().left;
    var elWidth = stars.width();
    var numStars = Math.ceil(((clickPosn - elPosn)/ elWidth)*5);
    this.model.set("rating", numStars)
    this.sendAjaxServer(numStars)
   },

  sendAjaxServer: function(numStars){
    var view = this;
    if (this.model.get("rated")){
      $.ajax({
        type: "PUT",
        url: "/api/user_rating_joins/" + this.model.get("rated_join_id"),
        data: {user_rating_join: {movie_id: this.model.id, movie_rating: numStars}},
        success: function(){
          view.changeStore()
        }
      })    
    } else {
      $.ajax({
        type: "POST",
        url: "/api/user_rating_joins",
        data: {user_rating_join: {movie_id: this.model.id, movie_rating: numStars}},
        success: function(response){
          view.model.set("rated_join_id", response.id)
          view.model.set("rated", true)
          view.changeStore()   
        }        
      })   
    }
  },

  render: function(){
    var renderedContent = this.template({ movie: this.model});
    this.$el.html(renderedContent);
    return this;
  },
});
