MovieGenie.Views.GenresIndex = Backbone.View.extend({

  template: JST['genres/index'],
  tagName: "div  style='font-size:120%' class='row'",  
  initialize: function(){
    this.listenToOnce(this.collection,"sync", this.render)
  },

  render: function(){   
    var renderedContent = this.template({genres: this.collection});
    this.$el.html(renderedContent);

    return this;    
   }  

});
