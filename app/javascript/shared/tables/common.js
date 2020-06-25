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
        ...tableOptions
      };

      callback($table, options);
      setupLoadingIndicator($table);
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
