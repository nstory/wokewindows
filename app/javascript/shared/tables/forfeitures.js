import escape from "lodash/escape";
import {date_renderer, earnings_renderer, text_renderer} from "renderers";
import {initDataTable} from "shared/tables/common";

initDataTable("table.forfeitures-table", function($table, options) {
  $table.DataTable({
    ...options,
    columns: [
      {data: "sucv", render: sucv_renderer},
      {data: "date", render: date_renderer},
      {data: "amount", render: earnings_renderer},
      {data: "motor_vehicle", render: text_renderer},
      {data: "forfeitures_incidents", render: forfeitures_incidents_renderer}
    ]
  });
});

function sucv_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (!data || !data.length) {
    return '<span class="unknown">N/A</span>';
  }
  return `<a href="${row.url}">${escape(data)}</a>`;
}

function forfeitures_incidents_renderer(data, type, row) {
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
