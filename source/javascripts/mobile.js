$(function() {
  // mobile nav
  $('a.club-sandwich').click(function(event) {
    event.preventDefault();
    $('body').addClass('mobile-nav-is-showing');
  });

  $('a.nav__close').click(function(event) {
    event.preventDefault();
    $('body').removeClass('mobile-nav-is-showing');
  });
});
