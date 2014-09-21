/*===================================================================================*/
/*	SMOOTH SCROLL
/*===================================================================================*/ 
$(function (){
  $('.pagination ul').addClass('pagination');
});

$(function() {
  $('a[href*=#]:not([href=#])').click(function() {
    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
      if (target.length) {
        $('html,body').animate({
          scrollTop: target.offset().top
        }, 1000);
        return false;
      }
    }
  });
});
/*===================================================================================*/
/*	LIGHTBOX
/*===================================================================================*/
      $(document).ready(function() {
        $('.lightbox').magnificPopup({type:'image'});
      });

/*===================================================================================*/
/*	HEADER SHRINK
/*===================================================================================*/
      $(window).scroll(function () {
        if ($(document).scrollTop() < 120) {
          $('.navbar').removeClass('tiny');
        } else {
          $('.navbar').addClass('tiny');
        }
      });
      
/*===================================================================================*/
/*	CLOSE NAVBAR DROPDOWN WHEN LINK CLICKED ON MOBILE
/*===================================================================================*/
    // call jRespond and add breakpoints
    var jRes = jRespond([
        {
            label: 'handheld',
            enter: 0,
            exit: 767
        },{
            label: 'tablet',
            enter: 768,
            exit: 979
        },{
            label: 'laptop',
            enter: 980,
            exit: 1199
        },{
            label: 'desktop',
            enter: 1200,
            exit: 10000
        }
    ]);

    // register enter and exit functions for a single breakpoint
    jRes.addFunc({
        breakpoint: 'handheld',
        enter: function() {
          $('.navbar-collapse a').click(function(){
              $(".navbar-collapse").collapse('hide');
          });
        }
    });