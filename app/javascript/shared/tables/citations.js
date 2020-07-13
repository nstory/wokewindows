import escape from "lodash/escape";
import {text_renderer, date_time_renderer, earnings_renderer, yes_no_renderer, int_renderer, see_more_renderer, url_renderer, unknown} from "renderers";
import {initDataTable} from "shared/tables/common";

initDataTable("table.citations-table", function($table, options) {
  $table.DataTable({
    ...options,
    columns: [
      {data: "ticket_number", render: url_renderer(text_renderer)},
      {data: "links", render: yes_no_renderer, orderable: false},
      {data: "event_date", render: date_time_renderer},
      {data: "officer_number", render: officer_renderer, orderable: false},
      {data: "issuing_agency", render: agency_renderer},
      {data: "location_name", render: text_renderer},
      {data: "amount", render: earnings_renderer},
      {data: "ticket_type", render: text_renderer},
      {data: "source", render: text_renderer},
      {data: "violator_type", render: text_renderer},
      {data: "cdl", render: yes_no_renderer},
      {data: "license_class", render: text_renderer},
      {data: "posted_speed", render: int_renderer},
      {data: "violation_speed", render: int_renderer},
      {data: "posted", render: yes_no_renderer},
      {data: "radar", render: text_renderer},
      {data: "clocked", render: text_renderer},
      {data: "race", render: text_renderer},
      {data: "sex", render: text_renderer},
      {data: "make", render: text_renderer},
      {data: "model_year", render: int_renderer},
      {data: "vehicle_color", render: text_renderer},
      {data: "sixteen_pass", render: yes_no_renderer},
      {data: "haz_mat", render: yes_no_renderer},
      {data: "paid", render: yes_no_renderer},
      {data: "hearing_requested", render: yes_no_renderer},
      {data: "court_name", render: text_renderer, orderable: false},
      {data: "age", render: int_renderer},
      {data: "searched", render: yes_no_renderer},
      {data: "offenses", render: see_more_renderer, orderable: false},
    ],
    order: [[2, 'desc']]
  });
});

export function agency_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data == null) {
    return unknown();
  }
  return `<span>${escape(data.replace(/^Boston Police /, ''))}</span>`;
}

export function officer_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data == null) {
    return unknown();
  }
  if (row.officer_name && row.officer_url) {
    return escape(row.officer_name);
    // return `<a href="${escape(row.officer_url)}">${escape(row.officer_name)} (${escape(data)})</a>`;
  }
  return escape(data);
}
