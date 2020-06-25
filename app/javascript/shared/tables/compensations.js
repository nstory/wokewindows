import {earnings_renderer, zip_renderer} from "renderers";

// corresponding javascript for shared/_compensations_table.html.erb
$(document).on("turbolinks:load", function() {
  $("table.compensations-table").each(function() {
    const $table = $(this);
    const id = $table.attr("data-id");
    const data = window[id];

    dataTable($table, data);
  });
});

function dataTable($table, data) {
  $table.DataTable({
    data: data,
    columns: [
      {data: "year"},
      {data: "name"},
      {data: "department_name"},
      {data: "title"},
      {data: "regular", render: earnings_with_pct_renderer},
      {data: "retro", render: earnings_with_pct_renderer},
      {data: "other", render: earnings_with_pct_renderer},
      {data: "overtime", render: earnings_with_pct_renderer},
      {data: "injured", render: earnings_with_pct_renderer},
      {data: "detail", render: earnings_with_pct_renderer},
      {data: "quinn", render: earnings_with_pct_renderer},
      {data: "total", render: earnings_with_pct_renderer},
      {data: "postal", render: zip_renderer}
    ],
    info: false,
    order: [[0, 'desc']],
    paging: false,
    searching: false,
    scrollX: true,
    scrollY: 300,
    scrollResize: true
  });
}

const currency_format = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' });

function earnings_with_pct_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data) {
    const pct = Math.floor(data/row['total']*100) + "%";
    return `<div class="earnings"><span class="earnings__dollars">${currency_format.format(data)}</span> <span class="earnings__pct">${pct}</span></div>`;
  }
  return '<div style="text-align:center">-</div>';
}
