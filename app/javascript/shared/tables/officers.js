import {int_renderer, employee_id_renderer, employee_name_renderer, earnings_renderer, date_renderer, zip_renderer} from "renderers";

// corresponding javascript for shared/_officers_table.html.erb
$(document).on("turbolinks:load", function() {
  $("table.officers-table").DataTable({
    ajax: {
      url: "/officers.json",
      dataSrc: "officers"
    },
    columns: [
      {data: "employee_id", render: employee_id_renderer},
      {data: "name", render: employee_name_renderer},
      {data: "title"},
      {data: "doa", render: date_renderer},
      {data: "total_earnings", render: earnings_renderer},
      {data: "complaints_count", render: int_renderer},
      {data: "field_contacts_count", render: int_renderer},
      {data: "incidents_count", render: int_renderer},
      {data: "zip_code", render: zip_renderer}
    ],
    order: [[4, 'desc']],
    scrollX: true
  });
});

