(function($){

  var HabitRow = function(habit){
    var self = this;
    self.habit = habit;
    self.$elem = $("<div>").addClass("habit");
    $('<h2>').html(habit.attr("name")).appendTo(self.$elem);
    self.$elem.click(function(){self.showCalendar();});
    return self.$elem;
  };
  HabitRow.prototype = {
    showCalendar: function(){
      this.hideAllCalendars();
      if (this.$habitCalendar == null){
        this.$habitCalendar = this.createCalendar();
      }
      this.$habitCalendar.hide();
      this.$elem.append(this.$habitCalendar);
      this.$habitCalendar.slideDown();
    },
    hideAllCalendars: function(){
      $('.habit .calendar').slideUp();
    },
    createCalendar: function(){
      var cal = $('<div>').addClass("calendar");
      $.each(this.habit.allDays(), function(index, day){
        var day = $("<div>").addClass("day").html(day.getDate()+"/"+(day.getMonth()+1));
        day.appendTo(cal);
      });
      return cal;
    }
  };

  var HabitList = function($elem){
    var self = this;
    this.$elem = $elem;
    
    Habit.bind("habits.loaded", function(){
      $.each(Habit.all(), function(index, habit){
        self.addHabitRow(habit);
      });
    });
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