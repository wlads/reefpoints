$(function(){
  $('body').addClass((window.location.pathname.match(/([\w|-]+).html/g) || [''])[0].split(".html")[0]);
  $('input, textarea').inFieldLabel();
  $('h2.hire-us').click(function() {
    $(this).toggleClass('active');
    $('section#form-container').slideToggle(1000);
    return false;
  });
  $('.mobile-nav').toggle(function(){
    $('header ul').slideDown();
    return false;
  }, function(){
    $('header ul').slideUp();
    return false;
  });
  
  $('#search').liveUpdate('#index');
  $('#index article:gt(4)').hide();
  $('.show-all-posts').click(function(event) {
    event.preventDefault();
    $('#index article').fadeIn();
    $('.nothin').hide();
    window.viewedAll = true
    window.playedSound = false;
    $('.show-all-posts').hide();
  });
});

