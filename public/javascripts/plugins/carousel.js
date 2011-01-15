//////// Carousel ////////
(function($){
  $.fn.carousel = function(images, options) {
    var $target = $(this);
    $target.find('div').hide();
    $target.css("background", "none");
    var divs = [div(0)];
    $target.prepend(divs[0]);
    $(document).ready(function(){
      $(images).each(function(i){
        if (i == 0) {
          return;
        }
        var tmp = div(i, true);
        divs.push(tmp);
        divs[0].after(tmp);
      });
      setTimeout(transition, opt('display_length'));
    });

    function getImagePath(i) {
      return opt('images_path') + '/' + images[i][0];
    }
    
    function backgroundStyle(index) {
      return 'url(' + getImagePath(index) + ')';
    }
    
    function div(index, hidden) {
      var $e = $('<div>' + images[index][1] + '</div>');
      $e.css({
        position: 'absolute',
        top: 0,
        background: backgroundStyle(index),
        height: $target.height(),
        width: $target.width()
      });
      if (hidden) {
        $e.hide();
      }
      return $e;
    }
    
    function transition() {
      if (typeof this.counter == 'undefined') {
        this.counter = 0;
      }
      var prev = counter;
      this.counter = nextIndex(this.counter);
      $(divs[counter]).fadeIn(opt('transition_length'));
      $(divs[prev]).fadeOut(opt('transition_length'), function() {
        setTimeout(transition, opt('display_length'));
      });
    }
    
    function nextIndex(current) {
      current++;
      if (current >= images.length) {
        current = 0;
      }
      return current;
    }
    
    function opt(name) {
      if (typeof this.options == 'undefined') {
        this.options = $.extend({
          display_length: 5000,
          transition_length: 3000,
          images_path: ''
        }, options);
      }
      return this.options[name];
    }
  };
})(jQuery);