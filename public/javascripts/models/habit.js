var Habit = Model("habit", {
  persistence: Model.REST("/habits")
}, {
  startDate: function(){
    return Date.parse(this.attr("start_date"))
  },
  allDays: function(){
    var days = []
    for(var i = 0; i<=29; i++){
      days.push(this.startDate().addDays(i))
    }
    return days
  }
  
});



