MovieGenie.Views.UserNew = Backbone.View.extend({
  template: JST["users/new"],
  tagName: "div style='color: #FFFFFF; margin-top:15%'",
  events: {
    "submit form": "submit"
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

    if (params["user"]["password"] === params["user"]["confirm_password"]){
      MovieGenie.currentUser = new MovieGenie.Models.User(params["user"]);
      
      this.$el.html("");
      $(".alert-data").html("")                    
      $("#loading-data").html(MovieGenie.loadingGenie)  
              
      MovieGenie.currentUser.save({}, {
        success: function () {
          $("#loading-data").html("")        
          Backbone.history.navigate("#users/settings", { trigger: true });
        },
        error: function(response){
          $("#loading-data").html("") 
          MovieGenie.addAlert("Email has already been taken!")
          view.render()          
        }
      });
    } else {
      MovieGenie.addAlert("Passwords do not match. Please try again.")
      this.render()
    }
  }
});
