import escape from "lodash/escape";
import {date_renderer, earnings_renderer, text_renderer} from "renderers";
import {initDataTable} from "shared/tables/common";

initDataTable("table.swats-table", function($table, options) {
  $table.DataTable({
    ...options,
    columns: [
      {data: "swat_number", render: swat_number_renderer},
      {data: "date", render: date_renderer},
    ],
    order: [[1, 'desc']]
  });
});

function swat_number_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (!data || !data.length) {
    return '<span class="unknown">N/A</span>';
  }
  return `<a href="${row.url}">${escape(data)}</a>`;
}

