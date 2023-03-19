// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"
import jquery from "jquery"
import "@fortawesome/fontawesome-free"
window.$ = jquery

$(window).on('turbo:load turbo:render', ()=>{
  //パート入力フォーム
  $(function(){
    const activate_form = function(num) {
      $('.parts').eq(num).show();
    }

    const deactivate_form = function(num) {
      $('.parts').eq(num).hide();
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

  //ジャンル入力フォーム
  $(function(){

    const reset_params = function(num) {
      $('.other-genre').eq(num).val("").hide();
      $('.genre-name').eq(num).val(16);
    }

    if ($('.genre-name').first().val() == 16) {
      $('.genres').eq(1).hide();
      $('.genres').eq(2).hide();
    } else if ($('.genre-name').first().val() != 16 && $('.genre-name').eq(1).val() == 16) {
      $('.genres').eq(2).hide();
    }

    $('.genres').each(function(){
      var genre_name = $(this).find('.genre-name').val()
      if (genre_name == 15) {
        $(this).find('.other-genre').show();
      }
    });

    $('.genre-name').first().change(function(){
      if ($(this).val() == 16) {
        $('.other-genre').eq(0).val("").hide();
        reset_params(1);
        reset_params(2);
        $('.genres').eq(1).hide();
        $('.genres').eq(2).hide();
      } else if ($(this).val() == 15) {
        $('.other-genre').eq(0).show();
        $('.genres').eq(1).show();
      } else {
        $('.other-genre').eq(0).val("").hide();
        $('.genres').eq(1).show();
        if ($('.genre-name').eq(1).val() != 16) {
          $('.genres').eq(2).show();
        }
      }
    });

    $('.genre-name').eq(1).change(function(){
      if ($(this).val() == 16) {
        $('.other-genre').eq(1).val("").hide();
        reset_params(2);
        $('.genres').eq(2).hide();
      } else if ($(this).val() == 15) {
        $('.other-genre').eq(1).show();
        $('.genres').eq(2).show();
      } else {
        $('.other-genre').eq(0).val("").hide();
        $('.genres').eq(2).show();
      }
    });

    $('.genre-name').eq(2).change(function(){
      if ($(this).val() == 16) {
        $('.other-genre').eq(2).val("").hide();
      } else if ($(this).val() == 15) {
        $('.other-genre').eq(2).show();
      } else {
        $('.other-genre').eq(2).val("").hide();
      }
    });
  });

  //アップロードファイル削除時
  $(function(){
    $('.delete-avatar').click(function() {
      $('.avatar').html('<img class="avatar rounded-circle my-3" src="/assets/default-3e61fd5dbed2c9fbc17ab2c035668b0940109837057d0b73678e696904e8d7c1.png" width="150" height="150">');
    });

    $('.delete-movie').click(function() {
      $('.movie').html('<p>動画がありません</p>');
    });

    $('.delete-sound').click(function() {
      $('.sound').html('<p>音源がありません</p>');
    });
  });

  //タブの切り替え
  $(function(){
    $('.tab1__link').click(function(){
      var num = $(this).data('tab-body')
      //フォームの活性非活性
      $('.form-scout').prop('disabled', true);
      $('.form-scout-' + num).prop('disabled', false);
      //タブ、フォームの表示非表示
      $('.tab1__link').removeClass('on');
      $(this).addClass('on');
      $('.tab1-body__item').removeClass('on');
      $('.tab1-body__item').eq(num).addClass('on');
    });
  });

  $(function(){
    $('.user-scout-0').change(function(){
      $('.btn-scout-0').prop('disabled', true);
      if ($('.user-scout-0').eq(0).val() != "" && $('.user-scout-0').eq(2).val() != "") {
        $('.btn-scout-0').prop('disabled', false);
      }
    });

    $('.user-scout-1').change(function(){
      $('.btn-scout-1').prop('disabled', true);
      if ($('.user-scout-1').eq(0).val() != "" && $('.user-scout-1').eq(1).val() != "") {
        $('.btn-scout-1').prop('disabled', false);
      }
    });
  });

  $(function(){
    $('.band-scout-0').change(function(){
      $('.btn-scout-0').prop('disabled', true);
      if ($(this).val() != "") {
        $('.btn-scout-0').prop('disabled', false);
      }
    });
  });

  $(function(){
    $('.band-scout-1').change(function(){
      $('.btn-scout-1').prop('disabled', true);
      if ($(this).val() != "") {
        $('.btn-scout-1').prop('disabled', false);
      }
    });
  });
})
