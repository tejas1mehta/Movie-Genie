MovieGenie.Views.SessionNew = Backbone.View.extend({
  template: JST["sessions/new"],
  tagName: "div style='color: #FFFFFF; margin-top:15%'",
  events: {
    "submit form#login": "submit",
    "submit form#fb-login": "fbLogin",
  },

  render: function () {
    var renderedContent = this.template({});
    this.$el.html(renderedContent);
    return this;
  },

  submit: function (event) {
    var view = this;
    event.preventDefault();

    var params = $(event.currentTarget).serializeJSON();
    userSession = new MovieGenie.Models.Session(params["session"]);
    MovieGenie.currentUser = new MovieGenie.Models.User(params["session"])

    this.$el.html("");
    $(".alert-data").html("")              
    $("#loading-data").html(MovieGenie.loadingGenie)                
    
    userSession.save({}, {
      success: function (resp) {
      $("#loading-data").html("")        
        Backbone.history.navigate("movies/homepage", { trigger: true });
      },
      error: function(){
        $("#loading-data").html("") 
        MovieGenie.addAlert("Email/Password not recognized. Please try again.")
        view.render()           
      }
    });
  }
});

