jQuery.fn.liveUpdate = function(list){
  list = jQuery(list);

  if ( list.length ) {
    var rows = list.children('article'),
      cache = rows.map(function(){
        var $blogDetails = $(this).find('.index-post');
        var title = $blogDetails.find('h2 a').text().toLowerCase();
        var summary = $blogDetails.find('p').text().toLowerCase();
        return title + " " + summary;
      });

    this
      .keyup(filter).keyup()
      .parents('form').submit(function(){
        return false;
      });
  }

  return this;

  function filter(){
    var term = jQuery.trim( jQuery(this).val().toLowerCase() ), scores = [];

    if ( !term ) {
      rows.show();
      if ( window.viewedAll !== true ) {
        $('#index article:gt(4)').hide();
      };
      $('.nothin').hide();
    } else {
      rows.hide();

      cache.each(function(i){
        var score = this.score(term);
        if (score > 0) { scores.push([score, i]); }
      });

      var count = 0;
      
      jQuery.each(scores.sort(function(a, b){return b[0] - a[0];}), function(){
        count += 1;
        jQuery(rows[ this[1] ]).show();
      });

      if ( count === 0 ){
        $('.nothin').fadeIn();
        if ( window.playedSound !== true ) {
          $('.foghorn').get(0).play();
          window.playedSound = true;
        };
        $('.show-all-posts').show();
      } else {
        $('.nothin').hide();
        window.playedSound = false;
      };
    }
  }
};