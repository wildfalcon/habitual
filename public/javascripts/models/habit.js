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
      console.log("Found object;", this.attr("last_completed_date"));
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
  completableDate: function(){
    var cd;
    if(this.lastCompletedDate() == null){
      cd = this.startDate();
    } else {
      cd = this.lastCompletedDate().clone();
      cd.add(1).days();
    }
    console.log("completableDate is", cd);
    return cd;
  },
  completeDate: function(date){ 
    if(date.equals(this.completableDate())){
      console.log("Day can be completed");
      this.attr("last_completed_date", date);
      this.save();
      return true;
    } else {
      console.log("Day cannot be completed");
      return false;
    }
  }  
});



