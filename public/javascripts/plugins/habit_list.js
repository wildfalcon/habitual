(function($){

  ////////////////////////////////////////////
  //An individual day within a habit calendar
  ///////////////////////////////////////////
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

  /////////////////////////////////////////////
  //A habit calendar
  ////////////////////////////////////////////
  var HabbitCalendar = function(habit){
    var self = this;
    self.habit = habit;
    self.$elem = $("<div>").addClass("habit");

    var $titleDiv = $('<div class="title">');
    
    $('<h2>').html(habit.attr("name")).appendTo($titleDiv);
    
    var $deleteForm = $("<form>").addClass("delete_form").append("<button>Delete</button>");
    $deleteForm.attr("action", "#/habits/"+habit.id());
      
    $deleteForm.find('button').bind("click", function(evt){
      var confirmed = confirm("Are you sure you wish to delete?");
      if(confirmed){
        $(this).parent().submit(); //IE7 needs this explicitly
      }
      evt.stopPropagation();
      return false;
    });
    $deleteForm.prepend($('<input>').attr({type: 'hidden', name: '_method', value: 'delete'}));
    $deleteForm.appendTo($titleDiv);

		$titleDiv.appendTo(self.$elem);
    
    self.habit.bind("remove", function(){
      self.$elem.fadeOut(600, function(){
        self.$elem.remove();
      });
    })
    
    self.$elem.click(function(){self.showCalendar();});
    return self.$elem;
  };
  HabbitCalendar.prototype = {
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
        var $day = $("<div>").addClass("day").html(date.getDate()+"/"+(date.getMonth()+1));
        new HabitDay($day, self.habit, date);
        $day.appendTo(cal);
      });
      return cal;
    }
  };


  /////////////////////////////////////////
  // A list of habits
  /////////////////////////////////////////
  var HabitList = function($elem){
    var self = this;
    this.$elem = $elem;
    
    Habit.bind("add", function(habit){
      self.addHabbitCalendar(habit);
    });
    
  };
  HabitList.prototype = {
    addHabbitCalendar: function(habit){
      var cal = new HabbitCalendar(habit);
      this.$elem.append(cal);
    }
  };

  ///////////////////////////////////////////////
  // The JQuery plugin
  ///////////////////////////////////////////////
  $.fn.habitList = function(){
    this.each(function(){
      new HabitList($(this));
    });
    return this;
  };


})(jQuery);