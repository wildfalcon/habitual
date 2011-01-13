var Habit = Model("habit", {
	persistence: Model.REST("/habits")
}, {
  initialize: function() {
    
    // Give it a uid
    if(this.attr("uid") == null){
      this.attr('uid', Math.uuid(8, 36).toLowerCase());
      this.attr("start_date", Date.today());
    } 

  },
  parseDateFromAttribute: function(attr_name){
    if (typeof(this.attr(attr_name)) == "string"){
		  var parsed_date = Date.parse(this.attr(attr_name));
		  if (parsed_date == null) { // happens if we are reading from local storage
		    parsed_date = Date.parse(this.attr(attr_name).match(/(.*)T/)[1]);
		  }
		  return parsed_date;
	  } else {
			return this.attr(attr_name);
		}
  },
  lastCompletedDate: function(){
    return this.parseDateFromAttribute("last_completed_date");
	},
	startDate: function(){
    return this.parseDateFromAttribute("start_date");
	},
	allDays: function(){
		var days = [];
		var day = this.startDate().clone();
		for(var i = 0; i<=29; i++){
			var nextDay = day.clone().addDays(i)
			days.push(nextDay);
		}
		return days;
	},
	nextDate: function(){
		var cd;
		if(this.lastCompletedDate() == null){
			cd = this.startDate();
		} else {
			cd = this.lastCompletedDate().clone();
			cd.add(1).days();
		}
		return cd;
	},
	completableDate: function(date){
		var next = date.equals(this.nextDate());
		var notFuture = date.compareTo(Date.today()) < 1;
		return (next && notFuture);
	},
	completedDate: function(date){
		if (this.lastCompletedDate()){
			var beforeCompletedDate = this.lastCompletedDate().compareTo(date)>0;
			var isCompletedDate = this.lastCompletedDate().compareTo(date)==0;
			return ( beforeCompletedDate || isCompletedDate )
		}
	},
	restart: function(){
		this.attr("start_date", Date.today());
		this.attr("last_completed_date", null)
		this.save(function(success){
			if(success){
				this.trigger("restarted");
			}
		});
		return false;
	},
	completed: function(){
		var lcd = this.lastCompletedDate().clone();
		var sd = this.startDate().clone();
		var completed = (sd.add(29).days().compareTo(lcd) < 1);
		return completed;
	},
	completeDate: function(date){ 
		var self = this;
		if(this.completableDate(date)){
			this.attr("last_completed_date", date);
			this.save(function(success){
				if (success==true){
					self.trigger("updated");
				}
			});
			return true;
		} else {
			return false;
		}
	}  
});



