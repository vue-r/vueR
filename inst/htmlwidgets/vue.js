HTMLWidgets.widget({

  name: 'vue',

  type: 'output',

  factory: function(el, width, height) {

    var instance = {};

    return {

      renderValue: function(x) {
        // if x.el is specified then use it and
        //   hide our htmlwidget container
        if(x.el) {
          el.style.display = "none";
        } else {
          // x.el not specified so use our htmlwidget el
          //  container for our Vue app but this will
          //  will probably not work as expected
          //  since the tag is just a div
          x.el = "#" + el.id;
        }

        this.instance = new Vue(x);

      },

      resize: function(width, height) {

        // for now ignore resize hopefully without
        //   much consequence

      },

      instance: instance

    };
  }
});
