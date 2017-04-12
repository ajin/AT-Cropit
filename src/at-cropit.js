( function( $, util ) {

/**
 * @param {String} pRegionId
 * @param {Object} [pOptions]
 **/
atcropit = function( itemId, options ) {
  var item = '#' + util.escapeCSS( itemId );

  var defaults = {
    source_type : 'COLLECTION',

    onFileChange: function(object) {
      apex.event.trigger(item, "at-cropit-onfilechange", {object});
    },
    onFileReaderError: function() {
      apex.event.trigger(item, "at-cropit-onfilereadererror", {});
    },
    onImageLoading: function() {
      apex.event.trigger(item, "at-cropit-onimageloading", {});
    },
    onImageLoaded: function() {
      apex.event.trigger(item, "at-cropit-onimageloaded", {});
    },
    onImageError: function(object, number, string) {
      apex.event.trigger(item, "at-cropit-onimageerror", {object, number, string});
    },
    onZoomEnabled: function() {
      apex.event.trigger(item, "at-cropit-onzoomenabled", {});
    },
    onZoomDisabled: function() {
      apex.event.trigger(item, "at-cropit-onzoomdisabled", {});
    },
    onZoomChange: function(number) {
      apex.event.trigger(item, "at-cropit-onzoomchange", {number});
    },
    onOffsetChange: function(object) {
      apex.event.trigger(item, "at-cropit-onoffsetchange", {object});
    }
  }
  var options = $.extend(defaults, options);

  $(item).cropit(options);
  $(item).cropit('imageSrc', options.defaultImageSrc);

  $("form").submit(function(e){
    e.preventDefault();

    // if user selects collection as source, it will first upload
    // to application_collectino
    if (options.source_type == 'COLLECTION'){
      var currentTarget = e.target;
      onSubmit(function(){
        currentTarget.submit();
      });
    }
  });

  function onSubmit(callback){
    var imageData = $(item).cropit('export', {
        type: options.type,
        quality: options.quality,
        originalSize: options.originalSize
    });

    var fileInput = $(item).find('input.cropit-image-input');
    var name = fileInput[0].files.length ? fileInput[0].files[0].name : "unknown";
    apex.server.plugin ( options.ajax_identifier,
                        { x01: name,
                          x02: options.type,
                          f01: imageData.split("base64,")[1]
                        },
              {
                cache: false,
              success: function( data ) {
                apex.debug.log("success");
                $(fileInput).val('');
                callback();
              }
    });

  }
}
})( apex.jQuery, apex.util );
