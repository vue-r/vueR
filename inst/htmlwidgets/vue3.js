HTMLWidgets.widget({

  name: 'vue3',

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

        // Vue 3 requires data to be a function
        //  so if not a function then we will auto-convert to a function
        if(typeof(x.data) !== 'function') {
          var dat = Object.assign({}, x.data);
          x.data = function() {return dat};
        }

        this.instance = Vue.createApp(x).mount(x.el);

      },

      resize: function(width, height) {

        // for now ignore resize hopefully without
        //   much consequence

      },

      instance: instance

    };
  }
});
