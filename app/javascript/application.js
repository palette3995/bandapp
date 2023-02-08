// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"
import jquery from "jquery"
window.$ = jquery

//マイページ編集画面のパート選択部分

$(function(){
  const activate_form = function(num) {
    $('.parts').eq(num).find('select,input').prop('disabled', false);
  }

  const deactivate_form = function(num) {
    $('.parts').eq(num).find('select,input').prop('disabled', true);
  }

  const hide_other_part_and_level = function(num) {
    $('.other-part').eq(num).val("").hide();
    $('.level').eq(num).val("").hide();
  }

  const reset_params = function(num) {
    hide_other_part_and_level(num);
    $('.part-name').eq(num).val(7);
  }

  const show_other_part_and_level = function(num) {
    $('.other-part').eq(num).show();
    $('.level').eq(num).show();
  }

  const hide_other_part_and_show_level = function(num) {
    $('.other-part').eq(num).val("").hide();
    $('.level').eq(num).show();
  }


  if ($('.part-name').first().val() == 7) {
    deactivate_form(1);
    deactivate_form(2);
  } else if ($('.part-name').first().val() != 7 && $('.part-name').eq(1).val() == 7) {
    deactivate_form(2);
  }

  $('.parts').each(function(){
    var part_name = $(this).find('.part-name').val()
    if (part_name == 6) {
      $(this).find('input').show();
    } else if (part_name == 7) {
      $(this).find('.level').hide();
    }
  });

  $('.part-name').first().change(function(){
    if ($(this).val() == 7) {
      hide_other_part_and_level(0);
      reset_params(1);
      reset_params(2);
      deactivate_form(1);
      deactivate_form(2);
    } else if ($(this).val() == 6) {
      show_other_part_and_level(0);
      activate_form(1);
    } else {
      hide_other_part_and_show_level(0);
      activate_form(1);
      if ($('.part-name').eq(1).val() != 7) {
        activate_form(2);
      }
    }
  });

  $('.part-name').eq(1).change(function(){
    if ($(this).val() == 7) {
      hide_other_part_and_level(1);
      reset_params(2);
      deactivate_form(2);
    } else if ($(this).val() == 6) {
      show_other_part_and_level(1);
      activate_form(2);
    } else {
      hide_other_part_and_show_level(1);
      activate_form(2);
    }
  });

  $('.part-name').eq(2).change(function(){
    if ($(this).val() == 7) {
      hide_other_part_and_level(2);
    } else if ($(this).val() == 6) {
      show_other_part_and_level(2);
    } else {
      hide_other_part_and_show_level(2);
    }
  });
});
