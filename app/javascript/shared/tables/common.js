import get from "lodash/get";

// don't show errors in an alert()
$.fn.dataTable.ext.errMode = 'throw';

// clean up any old datatables before rendering a new page, otherwise
// datatables stores the old tables which is a memory leak
$(document).on("turbolinks:before-render", function() {
  $.fn.dataTable.tables().forEach((e) => {
    $(e).dataTable().api().state.save();
    $(e).dataTable().api().destroy();
  });
});

export function initDataTable(selector, callback) {
  $(document).on("turbolinks:load", function() {
    $(selector).each(function() {
      const $table = $(this);
      const url = $table.data("source");
      const tableOptions = $table.data("options") || {};

      const options = {
        ajax: {
          url: url,
          type: "POST"
        },
        searchDelay: 0,
        serverSide: true,
        scrollX: true,
        scrollY: 300,
        deferRender: true,
        scroller: {
          displayBuffer: 20
        },
        processing: true,
        scrollResize: true,
        language: {
          info: "Showing _TOTAL_ entries"
        },
        stateSave: true,
        stateDuration: -1, // use SessionStorage
        stateLoadParams: function(settings, data) {
          // only load saved state if this is a restoration visit i.e. user got
          // here via the back button
          const action = get(Turbolinks, "controller.currentVisit.action")
          if (action != "restore") {
            return false;
          }
          return undefined;
        },
        ...tableOptions
      };

      callback($table, options);
      setupLoadingIndicator($table);

      $table.on("click", "tbody tr[role=row] td", function(ev) {
        // if user clicked on a link, let the link change the page
        if ($(ev.target).is("a")) {
          return;
        }

        // if this row is associated with a url, open the url
        const table = $table.DataTable();
        const data = table.row(this).data();
        if (data && data.url) {
          Turbolinks.visit(data.url);
        }
      })
    });
  });
}

function setupLoadingIndicator($table) {
  const $wrapper = $table.closest(".dataTables_wrapper");
  $wrapper.append(`
    <div class="table-loading">
      <div class="spinner-border" />
    </div>
  `)
  $wrapper.addClass("loading");
  $table.on("processing.dt", function(e, settings, processing) {
    $wrapper.toggleClass("loading", processing);
  });
}
