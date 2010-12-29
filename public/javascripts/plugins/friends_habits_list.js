(function($){

  /////////////////////////////////////////
  // A list of Completed
  /////////////////////////////////////////
  var FriendsHabitsList = function($elem){
		var self = this;
		this.$elem = $elem;
		
		FriendsHabit.bind("add", function(friends_habit){
			self.addFriendHabit(friends_habit)
		})
	};
  FriendsHabitsList.prototype = {
		addFriendHabit: function(friends_habit){
			var $fh = $('<div>').addClass("friends_habit")
			$('<img>').attr("src", friends_habit.attr("image")).appendTo($fh);
			var $text = $('<div>').appendTo($fh)
			$('<h3>').html(friends_habit.attr("name")).appendTo($text);
			$('<p>').html(friends_habit.attr("habit_name")).appendTo($text);
			
			$fh.appendTo(this.$elem);
		}
  };

  ///////////////////////////////////////////////
  // The JQuery plugin
  ///////////////////////////////////////////////
  $.fn.friendsHabitsList = function(){
      new FriendsHabitsList($(this));
    return this;
  };


})(jQuery);