# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
namespace = (name) ->
  window[name] = window[name] or {}

page_ready = ->
  $('#spinner').show()
  $('body').css({opacity: 0.5})

page_load = ->
  $('#body [title]').filter(':not([data-toggle="popover"])').tooltip({});
  $('#body [data-toggle="popover"]').popover()
  $('#spinner').hide()
  $('body').css({opacity: 1})

namespace 'FormUtils'

FormUtils.show_errors = (form, errors) ->
  form.find('.error-explanation').remove()

  if(errors.length)
    errorsLi = ''
    errorsLi += '<li>' + error + '</li>' for error in errors

    errorsTmpl =
      '<div class="error-explanation">' + '<div class="alert alert-danger">' + 'Форма содержит ошибки' + '</div>' + '<ul>' + errorsLi + '</ul>' + '</div>';

    form.prepend(errorsTmpl);

#handle ajax calls
$(document).ajaxStart(page_load);
$(document).ajaxStop(page_load);

#handle turbolinks call
$(document).ready(page_load);
$(document).on('page:load', page_load);
$(document).on('page:restore', page_load);
$(document).on('page:fetch', page_ready);