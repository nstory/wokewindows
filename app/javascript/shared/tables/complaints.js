import escape from "lodash/escape";
import uniq from "lodash/uniq";
import {array_renderer, int_renderer, text_renderer, date_renderer, unknown} from "renderers";
import {initDataTable} from "shared/tables/common";

initDataTable("table.complaints-table", function($table, options) {
  $table.DataTable({
    ...options,
    columns: [
      {data: "ia_number", render: ia_number_renderer},
      {data: "case_number", render: int_renderer},
      {data: "incident_type", render: text_renderer},
      {data: "received_date", render: date_renderer},
      {data: "occurred_date", render: date_renderer},
      {data: "complaint_officers", render: complaint_officers_renderer},
    ],
    order: [[3, 'desc']]
  });
});

function ia_number_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (!data) {
    return "";
  }
  return `<div class="text-center"><a href="${row.url}">${escape(data)}</a></div>`;
}

function complaint_officers_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data == null) {
    return unknown();
  }
  return uniq(data).map((v) => escape(v)).join("; ");
}
