import {date_time_renderer, int_renderer, see_more_renderer, text_renderer, title_renderer, unknown, yes_no_renderer,  zip_renderer} from "renderers";
import {initDataTable} from "shared/tables/common";

initDataTable("table.field-contacts-table", function($table, options) {
  $table.DataTable({
    ...options,
    columns: [
      {data: "fc_num", render: fc_num_renderer},
      {data: "contact_date", render: date_time_renderer},
      {data: "contact_officer_name", render: title_renderer},
      {data: "supervisor_name", render: title_renderer},
      {data: "street", render: title_renderer},
      {data: "city", render: title_renderer},
      {data: "state", render: uppercase_renderer},
      {data: "zip", render: zip_renderer},
      {data: "frisked_searched", render: yes_no_renderer},
      {data: "search_vehicle", render: yes_no_renderer},
      {data: "stop_duration", render: duration_renderer},
      {data: "circumstance", render: title_renderer},
      {data: "basis", render: title_renderer},
      {data: "vehicle_year", render: int_renderer},
      {data: "vehicle_state", render: uppercase_renderer},
      {data: "vehicle_make", render: title_renderer},
      {data: "vehicle_model", render: title_renderer},
      {data: "vehicle_color", render: title_renderer},
      {data: "vehicle_style", render: title_renderer},
      {data: "vehicle_type", render: title_renderer},
      {data: "key_situations", render: see_more_renderer},
      {data: "weather", render: title_renderer},
      {data: "field_contact_names_count", render: int_renderer},
      {data: "narrative", render: narrative_renderer}
    ],
    order: [[1, 'desc']]
  });
});

function fc_num_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (!data) {
    return "";
  }
  return `<a href="${row.url}">${escape(data)}</a>`;
}

function uppercase_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (!data) {
    return unknown();
  }
  return data.toUpperCase();
}

function duration_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  switch (data) {
    case "five_to_ten_minutes":
      return "5m - 10m";
    case "fifteen_to_twenty_minutes":
      return "15m - 20m";
    case "ten_to_fifteen_minutes":
      return "10m - 15m";
    case "less_than_five_minutes":
      return "< 5m";
    case "longer_than_two_hours":
      return "> 2h";
    case "thirty_to_forty_five_minutes":
      return "30m - 45m";
    case "one_to_two_hours":
      return "1h - 2h";
    case "twenty_five_to_thirty_minutes":
      return "25m - 30m";
    case "twenty_to_twenty_five_minutes":
      return "20m - 25m";
    case "forty_five_to_sixty_minutes":
      return "45m - 60m";
  }
  return unknown();
}

function narrative_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data == null) {
    return  unknown();
  }
  const normalized = data.replace(/\s+/g, " ")
  const shortened = normalized.slice(0, 45);
  const more = shortened.length != normalized.length;
  let text = shortened;
  if (more) {
    text += `... <a href="${row.url}">See more</a>`;
  }
  return text;
}
