import escape from "lodash/escape";
import uniq from "lodash/uniq";
import {array_renderer, int_renderer, text_renderer, date_renderer, unknown, see_more_renderer} from "renderers";
import {initDataTable} from "shared/tables/common";

initDataTable("table.complaints-table", function($table, options) {
  $table.DataTable({
    ...options,
    columns: [
      {data: "ia_number", render: ia_number_renderer},
      {data: "incident_type", render: text_renderer},
      {data: "received_date", render: date_renderer},
      {data: "complaint_officers", render: see_more_renderer, orderable: false},
      {data: "complaint_allegations", render: see_more_renderer, orderable: false},
      {data: "finding", render: text_renderer, orderable: false}
    ],
    order: [[2, 'desc']]
  });
});

function ia_number_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (!data) {
    return "";
  }
  return `<a href="${row.url}">${escape(data)}</a>`;
}
