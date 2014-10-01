MovieGenie.Views.CastSearchResults = Backbone.CompositeView.extend({
  template: JST["users/castsearchresults"],
  
  initialize: function(options){
    this.keywords = options.keywords
    this.item = options.item
    MovieGenie.currentRouter.navigate("#users/" + options.item + "-search") 
  },

  render: function(){
    renderedContent = this.template({collection: this.collection, keywords: this.keywords, item: this.item});
    this.$el.html(renderedContent)
    return this
  },

});
