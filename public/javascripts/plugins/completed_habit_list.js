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
			if (self.$elem.find("#head").length==0) {
				var $head = $('<div id="head">')
				$("<h2>").html("Completed Habits").appendTo($head);
				$head.appendTo(self.$elem);
			}
			
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