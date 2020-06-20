// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

window.jQuery = window.$ = require("jquery");
require("jquery-ujs");
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

require("bootstrap");

require("datatables.net-dt");
require("datatables.net-buttons-dt");
require("datatables.net-buttons/js/buttons.html5.js");
require("datatables.net-scroller-dt");
require("datatables.net-plugins/features/scrollResize/dataTables.scrollResize.js");

require("shared/tables/compensations");
require("shared/tables/complaints");
require("shared/tables/field_contacts");
require("shared/tables/incidents");
require("shared/tables/officers");

require("shared/maps/incident");

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
