import {int_renderer, employee_id_renderer, employee_name_renderer, earnings_renderer, date_renderer, zip_renderer, text_renderer} from "renderers";

$(document).on("turbolinks:load", function() {
  $("table.officers-table").each(function() {
    initDataTable($(this));
  });
});

function initDataTable($table) {
  $table.DataTable({
    ajax: {
      url: $table.data("source"),
      type: "POST"
    },
    pagingType: "full_numbers",
    processing: true,
    searchDelay: 1000,
    serverSide: true,
    columns: [
      {data: "employee_id", render: employee_id_renderer},
      {data: "name", render: employee_name_renderer},
      {data: "title", render: text_renderer},
      {data: "doa", render: date_renderer},
      {data: "postal", render: zip_renderer},
      {data: "state", render: text_renderer},
      {data: "city", render: text_renderer},
      {data: "total", render: earnings_renderer},
      {data: "regular", render: earnings_renderer},
      {data: "retro", render: earnings_renderer},
      {data: "other", render: earnings_renderer},
      {data: "overtime", render: earnings_renderer},
      {data: "injured", render: earnings_renderer},
      {data: "detail", render: earnings_renderer},
      {data: "quinn", render: earnings_renderer},
      {data: "complaints_count", render: int_renderer},
      {data: "field_contacts_count", render: int_renderer},
      {data: "incidents_count", render: int_renderer}
    ],
    order: [[7, 'desc']],
    scrollX: true
  });
}

