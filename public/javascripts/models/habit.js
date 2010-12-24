var Habit = Model("habit", {
	persistence: Model.REST("/habits")
}, {
	startDate: function(){
		return Date.parse(this.attr("start_date"));
	},
	lastCompletedDate: function(){
		if (typeof(this.attr("last_completed_date")) == "string"){
			return Date.parse(this.attr("last_completed_date"));
		} else {
			return this.attr("last_completed_date");
		}
	},
	allDays: function(){
		var days = [];
		for(var i = 0; i<=29; i++){
			days.push(this.startDate().addDays(i));
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
	completeDate: function(date){ 
		if(this.completableDate(date)){
			this.attr("last_completed_date", date);
			this.save();
			return true;
		} else {
			return false;
		}
	}  
});



