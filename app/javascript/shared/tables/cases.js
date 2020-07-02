import escape from "lodash/escape";
import {date_renderer, earnings_renderer, text_renderer} from "renderers";
import {initDataTable} from "shared/tables/common";

initDataTable("table.cases-table", function($table, options) {
  $table.DataTable({
    ...options,
    columns: [
      {data: "case_number", render: case_number_renderer},
      {data: "court_name", render: text_renderer},
      {data: "date", render: date_renderer},
      {data: "amount", render: earnings_renderer},
      {data: "motor_vehicle", render: text_renderer},
      {data: "cases_incidents", render: cases_incidents_renderer, orderable: false}
    ],
    order: [[2, 'desc']]
  });
});

function case_number_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (!data || !data.length) {
    return '<span class="unknown">N/A</span>';
  }
  return `<a href="${row.url}">${escape(data)}</a>`;
}

function cases_incidents_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (!data || !data.length) {
    return '<span class="unknown">N/A</span>';
  }
  return data.map((v) => {
    if (v.url) {
      return `<a href="${escape(v.url)}">${escape(v.incident_number)}</a>`;
    }
    return escape(v.incident_number);
  }).join(", ");
}
