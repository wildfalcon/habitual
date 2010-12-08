(function($){

  var HabitRow = function(habit){
    var self = this
    self.$elem = $("<div>").addClass("habit");
    $('<h2>').html(habit.attr("name")).appendTo(self.$elem);
    return self.$elem;
  }

  var HabitList = function($elem){
    var self = this;
    this.$elem = $elem;
    
    Habit.bind("habits.loaded", function(){
      $.each(Habit.all(), function(index, habit){
        self.addHabitRow(habit);
      });
    })
  };
  HabitList.prototype = {
    addHabitRow: function(habit){
      console.log("adding row for", habit.attr("name"));
      var row = new HabitRow(habit);
      this.$elem.append(row);
    }
  };

  $.fn.habitList = function(){
    this.each(function(){
      new HabitList($(this));
    });
    return this;
  };

})(jQuery);