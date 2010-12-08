var Habit = Model("habit", {
  persistence: Model.REST("/habits")
})


// wait for the document to load
$(function() {
  Habit.load(function() {
    Habit.trigger('habits.loaded');
  })
})