(function($){

  /////////////////////////////////////////
  // A list of Completed
  /////////////////////////////////////////
  var CompletedHabitList = function($elem){
    var self = this;
    this.$elem = $elem;
    
    CompletedHabit.bind("add", function(completed_habit){
      self.addCompletedHabit(completed_habit);
    });

    
  };
  CompletedHabitList.prototype = {
		addCompletedHabit: function(completed_habit){
			var self = this;
			
			
			//Factor this into own class if complexity grows
			//create markup
			var $ch = $("<div>").addClass("completed_habit");
			$ch.html(completed_habit.attr("name"))
			$ch.appendTo(self.$elem);
		}
  };

  ///////////////////////////////////////////////
  // The JQuery plugin
  ///////////////////////////////////////////////
  $.fn.completedHabits = function(){
      new CompletedHabitList($(this));
    return this;
  };


})(jQuery);