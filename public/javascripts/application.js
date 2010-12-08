// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var Habit = Model("habit", {
  persistence: Model.REST("/habits")
})


// wait for the document to load
$(function() {
  Habit.load(function() {
    console.log("loaded")
  })
})