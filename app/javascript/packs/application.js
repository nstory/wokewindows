import { Application } from "stimulus";
import { definitionsFromContext } from "stimulus/webpack-helpers";

window.jQuery = window.$ = require("jquery");
require("jquery.redirect");
require("jquery-ujs");
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

// load stimulus and controllers
const application = Application.start();
const context = require.context("controllers", true, /\.js$/);
application.load(definitionsFromContext(context));

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
require("shared/charts/compensations");
require("toc");

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
