# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

page_ready = ->
  $('#spinner').show()
  $('body').css({opacity: 0.5})

page_load = ->
  $('#body [title]').tooltip({});
  $('#spinner').hide()
  $('body').css({opacity: 1})

#handle ajax calls
$(document).ajaxStart(page_load);
$(document).ajaxStop(page_load);

#handle turbolinks call
$(document).ready(page_load);
$(document).on('page:load', page_load);
$(document).on('page:restore', page_load);
$(document).on('page:fetch', page_ready);