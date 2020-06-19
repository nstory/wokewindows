import escape from "lodash/escape";
import {int_renderer, date_time_renderer, text_renderer, see_more_renderer} from "renderers";
import {initDataTable} from "shared/tables/common";

initDataTable("table.incidents-table", function($table, options) {
  $table.DataTable({
    ...options,
    columns: [
      {data: "incident_number", render: incident_num_renderer},
      {data: "occurred_on_date", render: date_time_renderer},
      {data: "district", render: text_renderer},
      {data: "shooting", render: shooting_renderer},
      {data: "location_of_occurrence", render: see_more_renderer},
      {data: "street", render: text_renderer},
      {data: "nature_of_incident", render: see_more_renderer},
      {data: "offenses", render: see_more_renderer},
      {data: "incident_officers", render: see_more_renderer}
    ],
    order: [[1, 'desc']]
  });
});

function incident_num_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (!data) {
    return "";
  }
  return `<div class="text-center"><a href="${row.url}">${escape(data)}</a></div>`;
}

function shooting_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data == null) {
    return '<span class="unknown">N/A</span>';
  }
  return data ? '<span class="text-danger">Y</span>' : '<span class="text-muted">N</span>';
}
