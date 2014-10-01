MovieGenie.CollectionMixIn = {
  showObjects: function(numScrolls){
    var startModelIndex = MovieGenie.resultsPerPage*numScrolls;
    var endModelIndex = MovieGenie.resultsPerPage*(numScrolls + 1);
    return this.models.slice(startModelIndex, endModelIndex)
  },

  getOrAdd: function(id){
    var retModel = this.get(id);
    if (!retModel){
      retModel = new this.model({id:id})
      this.add(retModel)
    }

    return retModel
  },

  getObjects: function(arrayIDs){
    var filteredCollection = new this.constructor();
    var sourceCollection = this;    

    filteredCollection.reset(sourceCollection.filter(function(object){
      return _.contains(arrayIDs, object.id)
    }));

    return filteredCollection
  },

  filterData: function(filteringCriteria){
      var filteredCollection = new this.constructor();
      var sourceCollection = this;

      filteredCollection.reset(sourceCollection.filter(function(expense){
        return (filteringCriteria.apply(expense))
      }));

      return filteredCollection
  },

  getOrFetch: function (id) {
    var curCollection = this;

    var curModel;
    if (curModel = this.get(id)) {
      curModel.fetch();
    } else {
      curModel = new this.model({ id: id });
      curModel.fetch({
        success: function () { curCollection.add(curModel,{merge:true, parse: true}); }
      });
    }

    return curModel;
  },
}
