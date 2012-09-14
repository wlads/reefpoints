jQuery.fn.liveUpdate = function(list){
  list = jQuery(list);

  if ( list.length ) {
    var rows = list.children('article'),
      cache = rows.map(function(){
        var $blogDetails = $(this).find('.blog-entries');
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
      $('#posts article:gt(4)').hide();
    } else {
      rows.hide();

      cache.each(function(i){
        var score = this.score(term);
        if (score > 0) { scores.push([score, i]); }
      });

      jQuery.each(scores.sort(function(a, b){return b[0] - a[0];}), function(){
        jQuery(rows[ this[1] ]).show();
      });
    }
  }
};