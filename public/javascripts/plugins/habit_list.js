(function($){

  ////////////////////////////////////////////
  //An individual day within a habit calendar
  ///////////////////////////////////////////
  var HabitDay = function(habit, date){
    var self = this;
    self.date = date;
    this.habit = habit;

		//Create Markup
		self.$day = $("<div>").addClass("day").html(date.getDate()+"/"+(date.getMonth()+1));

		if (this.habit.completedDate(date)){
			self.$day.addClass("completed");
		};

		if (this.habit.completableDate(date)){
			self.$day.addClass("completable");
		};
    
		//Set behaviours
		self.habit.bind("update", function(){
			if (self.habit.completedDate(date)){
        self.$day.removeClass("completable");
				self.$day.addClass("completed");
			};

			if (self.habit.completableDate(date)){
				self.$day.addClass("completable");
			};
		});

    self.$day.click(function(){
      self.markCompleted();
      return false;
    });

		return self.$day;
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

		//create markup
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
    
		//set behaviour
    self.habit.bind("remove", function(){
      self.$elem.fadeOut(600, function(){
        self.$elem.remove();
      });
    });

		self.habit.bind("updated", function(){
			if (self.habit.completed()==true){
				CompletedHabit.add(self.habit);
				self.$elem.fadeOut(900, function(){
					self.$elem.remove();
				});
			};
		});

		self.habit.bind("created_in_ui", function(){
			self.showCalendar();
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
        var $day = new HabitDay(self.habit, date);
        $day.appendTo(cal);
      });
      return cal;
    }
  };

	/////////////////////////////////////////
	// A Featured Habit
	/////////////////////////////////////////
	var FeaturedHabitView = function(featured_habit, $blank_slate){
			var self = this;
			self.featured_habit = featured_habit;
			self.$blank_slate = $blank_slate;
			
			// Create Markup
			self.$elem = $('<div>').addClass("featured_habit");
			$('<h3>').html(featured_habit.attr('title')).appendTo(self.$elem);
			$('<div>').html('<p>Every day for 30 days:</p><p> '+featured_habit.attr('name')+"</p>").appendTo(self.$elem);
			
			//Add behaviour
			self.$elem.click(function(){
				self.addAsHabit();
				self.hideBlankSlate();
			});
			return self.$elem;
	};
	FeaturedHabitView.prototype = {
		addAsHabit: function(){
			habit = new Habit();
			habit.attr("common_habit_id", this.featured_habit.id())
			habit.attr("name", this.featured_habit.attr('name'))
			habit.save(function(s){
				if(s==true){
					habit.trigger("created_in_ui");
				}
			})
		},
		hideBlankSlate: function(){
			this.$blank_slate.slideUp();
		}
	}

  /////////////////////////////////////////
  // A list of habits
  /////////////////////////////////////////
  var HabitList = function($elem){
    var self = this;
    this.$elem = $elem;
    
    Habit.bind("add", function(habit){
      self.addHabbitCalendar(habit);
    });

		FeaturedHabit.bind("add", function(featured_habit){
			self.addFeaturedHabit(featured_habit);
		})
    
  };
  HabitList.prototype = {
    addHabbitCalendar: function(habit){
      var cal = new HabbitCalendar(habit);
      this.$elem.append(cal);
    },
		addFeaturedHabit: function(featured_habit){			
			if (this.$blank_slate == null){
				this.$blank_slate = $('<div>').addClass("blank_slate");
				$('<h2>').html("Do something for 30 days, and it will become a habit.").appendTo(this.$blank_slate);
				$('<p>').html("Do your chosen task every day. But be dilligent, if you miss a day, you have to restart from day 1!").appendTo(this.$blank_slate);
				$('<p>').html("Pick something you want to try and make into a habit, then do it every day for 30 days. Or why not pick an idea from our popular habits?").appendTo(this.$blank_slate);
				$('<h2>').html("Popular Habits").appendTo(this.$blank_slate);
				this.$blank_slate.appendTo(this.$elem);
			}
			var $fh = new FeaturedHabitView(featured_habit, this.$blank_slate);
			this.$blank_slate.append($fh);
		}
  };

  ///////////////////////////////////////////////
  // The JQuery plugin
  ///////////////////////////////////////////////
  $.fn.habitList = function(){
    // this.each(function(){
      new HabitList($(this));
    // });
    return this;
  };


})(jQuery);