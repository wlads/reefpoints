$(function(){
  $('body').addClass((window.location.pathname.match(/([\w|-]+).html/g) || [''])[0].split(".html")[0]);
  $('input, textarea').inFieldLabel();

  $('#search').liveUpdate('#index');
  $('.show-all-posts').click(function(event) {
    event.preventDefault();
    $('#index article').fadeIn();
    $('.nothin').hide();
    window.viewedAll = true
    window.playedSound = false;
    $('.show-all-posts').hide();
  });

  // Art directed posts
  $('.design .post-title-wrap').bigtext({
    childSelector: '> h1',
    minfontsize: 40
  });
});