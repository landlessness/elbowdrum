// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function startHover(className) {
  $$(className).each(function(e) {
    e.addClassName('hover');
  })
}
function stopHover(className) {
  $$(className).each(function(e) {
    e.removeClassName('hover');
  })
}
