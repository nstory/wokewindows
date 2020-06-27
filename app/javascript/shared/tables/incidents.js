import escape from "lodash/escape";
import padEnd from "lodash/padEnd";
import {int_renderer, date_time_renderer, text_renderer, see_more_renderer, unknown} from "renderers";
import {initDataTable} from "shared/tables/common";

initDataTable("table.incidents-table", function($table, options) {
  $table.DataTable({
    ...options,
    columns: [
      {data: "incident_number", render: incident_num_renderer},
      {data: "occurred_on_date", render: date_time_renderer},
      {data: "district", render: district_renderer},
      {data: "shooting", render: shooting_renderer},
      {data: "location_of_occurrence", render: see_more_renderer},
      {data: "street", render: text_renderer},
      {data: "nature_of_incident", render: see_more_renderer},
      {data: "offenses", render: see_more_renderer},
      {data: "officer_journal_name", render: text_renderer}
    ],
    order: [[1, 'desc']]
  });
});

const districts = {
  "A1": "Downtown",
  "A15": "Charlestown",
  "A7": "East Boston",
  "B2": "Roxbury",
  "B3": "Mattapan",
  "C6": "South Boston",
  "C11": "Dorchester",
  "D4": "South End",
  "D14": "Brighton",
  "E5": "West Roxbury",
  "E13": "Jamaica Plain",
  "E18": "Hyde Park"
};

function district_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (!data) {
    return unknown();
  }
  const friendly = districts[data];
  if (friendly) {
    return `<span class="text-monospace">${padEnd(data, 3, "\u00a0")}</span> ${friendly}`;
  }
  return data;
}

function incident_num_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (!data) {
    return "";
  }
  return `<a href="${row.url}">${escape(data)}</a>`;
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
