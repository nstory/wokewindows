import {int_renderer, employee_id_renderer, employee_name_renderer, earnings_renderer, date_renderer, zip_renderer, na_renderer} from "renderers";

// corresponding javascript for shared/_officers_table.html.erb
$(document).on("turbolinks:load", function() {
  $("table.officers-table").DataTable({
    ajax: {
      url: "/officers.json"
    },
    pagingType: "full_numbers",
    processing: true,
    serverSide: true,
    columns: [
      {data: "employee_id", render: employee_id_renderer},
      {data: "name", render: employee_name_renderer},
      {data: "title"},
      {data: "doa", render: date_renderer},
      {data: "postal", render: zip_renderer},
      {data: "state", render: na_renderer},
      {data: "city", render: na_renderer},
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
});

