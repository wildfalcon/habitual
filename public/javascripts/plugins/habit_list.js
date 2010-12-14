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
      if (this.$habitCalendar == null){
        this.$habitCalendar = this.createCalendar();
        this.$habitCalendar.hide();
      }
      if (this.$habitCalendar.css("display")=="none"){
        this.hideAllCalendars();
        this.$habitCalendar.hide();
        this.$elem.append(this.$habitCalendar);
        this.$habitCalendar.slideDown();
      } else {
        this.$habitCalendar.slideUp();
      };
    },
    hideAllCalendars: function(){
      $('.habit .calendar').slideUp();
    },
    createCalendar: function(){
      var self = this;
      var cal = $('<div>').addClass("calendar");
      $.each(this.habit.allDays(), function(index, date){
        var day = $("<div>").addClass("day").html(date.getDate()+"/"+(date.getMonth()+1));
        day.habitDay(self.habit, date);
        day.appendTo(cal);
      });
      return cal;
    }
  };

  var HabitDay = function($day, habit, date){
    var self = this;
    self.$day = $day;
    self.date = date;
    this.habit = habit;
    
    if (this.habit.lastCompletedDate()){
      var beforeCompletedDate = this.habit.lastCompletedDate().compareTo(date)>0;
      var isCompletedDate = this.habit.lastCompletedDate().compareTo(date)==0;

      if ( beforeCompletedDate || isCompletedDate ){
        self.$day.addClass("completed");
      }
    }

    $day.click(function(){
      if (self.markCompleted()){
        self.$day.addClass("completed");
      }
      return false;
    });
  };
  HabitDay.prototype = {
    markCompleted: function(){
      return this.habit.completeDate(this.date);
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


  $.fn.habitDay = function(habit, date){
    this.each(function(){
      new HabitDay($(this), habit, date);
    });
    return this;
  };
})(jQuery);