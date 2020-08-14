import escape from "lodash/escape";
import padEnd from "lodash/padEnd";
import {int_renderer, date_time_renderer, text_renderer, see_more_renderer, yes_no_renderer, unknown} from "renderers";
import {initDataTable} from "shared/tables/common";

initDataTable("table.incidents-table", function($table, options) {
  $table.DataTable({
    ...options,
    columns: [
      {data: "incident_number", render: incident_num_renderer},
      {data: "links", render: yes_no_renderer, orderable: false},
      {data: "occurred_on_date", render: date_time_renderer},
      {data: "district", render: district_renderer},
      {data: "shooting", render: shooting_renderer},
      {data: "location_of_occurrence", render: location_renderer, orderable: false},
      {data: "offenses", render: offenses_renderer, orderable: false},
      {data: "officer_journal_name", render: text_renderer},
      {data: "incident_clearance", render: text_renderer},
      {data: "number_of_victims", render: int_renderer},
      {data: "number_of_offenders", render: int_renderer},
      {data: "number_of_arrestees", render: int_renderer},
    ],
    order: [[2, 'desc']]
  });
});

function incident_num_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (!data) {
    return "";
  }
  return `<a href="${row.url}">${escape(data)}</a>`;
}

function district_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (!data) {
    return unknown();
  }
  const friendly = row.district_name;
  if (friendly) {
    return `<span class="text-monospace">${padEnd(data, 3, "\u00a0")}</span> ${friendly}`;
  }
  return data;
}

function shooting_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  let res = "";
  if (data == null) {
    res = unknown();
  } else if (data) {
    res = '<span class="text-danger">Y</span>';
  } else {
    res = '<span class="text-muted">N</span>'
  }
  return `<div class="text-center">${res}</div>`;
}

function location_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data && data.length > 0) {
    return see_more_renderer(data, type, row);
  }
  return text_renderer(row.street, type, row);
}

function offenses_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data && data.length > 0) {
    return see_more_renderer(data, type, row);
  }
    return see_more_renderer(row.nature_of_incident, type, row);
}
