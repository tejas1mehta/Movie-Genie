MovieGenie.Views.UserSetting = Backbone.View.extend({
  template: JST["users/setting"],
  // tagName: "div style='color: #FFFFFF'",

  initialize: function(){
    if (MovieGenie.currentUser.get("genres_saved") === false){
      this.changeGenres()
    }    
    this.listenToOnce(this.collection,"sync", this.render)
  },

  events: {
    "click .rating-container" : "rateMovie",
    "submit form#genre-submit": "submit"
  },

  changeGenres: function(){
    this.collection.forEach(function(genre){
      genre.unset("percent_interest")
    })
  },

  render: function () {
    var renderedContent = this.template({allGenres: this.collection,
     genresSaved: MovieGenie.currentUser.get("genres_saved")});
    this.$el.html(renderedContent);
    return this;
  },

  rateMovie: function(event){
    var clickPosn = event.pageX;
    var genreDiv = $(event.currentTarget)//this.$(".rating-container")
    var genreId = parseInt(genreDiv.attr('id'))
    var elPosn = genreDiv.offset().left;
    var elWidth = genreDiv.width();
    var numStars = Math.ceil(((clickPosn - elPosn)/ elWidth)*5);
    MovieGenie.allGenres.get(genreId).set("percent_interest", numStars*20)
    MovieGenie.currentUser.set("genre" + (genreId - 1), (numStars - 3)/2)
    this.render()
   },

  submit: function (event) {

    // var view = this;
    event.preventDefault();
    this.$el.html("");
    $("#loading-data").html("<img class='movie-image img-responsive' src='" + MovieGenie.assetsUrl + "Predicting_genie.gif'>")            
    MovieGenie.currentUser.set("genres_saved", true)
    MovieGenie.currentUser.save({}, {
      success: function (resp) {
         $("#loading-data").html("")
        // Add user ID?
        // MovieGenie.createSession(resp)
        Backbone.history.navigate("#movies/homepage", { trigger: true });
      }
    });
  }
});

// <a href="<%= MovieGenie.url + 'auth/facebook' %>" style="display:inline-block"> <button class="btn fbLogin">  Sign In With Facebook </button> </a>
  // <a href="<%= MovieGenie.url + 'auth/facebook' %>"> <img alt="Facebook signin" src="<%= MovieGenie.assetsUrl + 'fb-register.png' %>"> </a>