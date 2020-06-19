export function initDataTable(selector, callback) {
  $(document).on("turbolinks:load", function() {
    $(selector).each(function() {
      const $table = $(this);

      const options = {
        ajax: {
          url: $table.data("source"),
          type: "POST"
        },
        pagingType: "full_numbers",
        searchDelay: 1000,
        serverSide: true,
        scrollX: true
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
