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
        processing: true,
        searchDelay: 1000,
        serverSide: true,
        scrollX: true
      };
      callback($(this), options);
    });
  });
}
