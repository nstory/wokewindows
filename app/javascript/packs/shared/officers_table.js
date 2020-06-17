// corresponding javascript for shared/_officers_table.html.erb
$(document).on("turbolinks:load", function() {
  $("table.officers-table").DataTable({
    ajax: {
      url: "/officers.json",
      dataSrc: "officers"
    },
    columns: [
      {data: "employee_id"},
      {data: "name"},
      {data: "title"},
      {data: "doa", render: date_renderer},
      {data: "total_earnings", render: earnings_renderer},
      {data: "complaints_count"},
      {data: "field_contacts_count"},
      {data: "incidents_count"}
    ]
  });
});

const currency_format = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' });

function earnings_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data) {
    return `<div class="text-monospace" style="text-align:right">${currency_format.format(data)}</span>`;
  }
  return '<div style="text-align:center">-</div>';
}

function date_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  return `<span class="text-monospace">${data}</span>`;
}
