import {date_time_renderer, int_renderer, see_more_renderer, text_renderer, unknown, yes_no_renderer,  zip_renderer} from "renderers";
import {initDataTable} from "shared/tables/common";

initDataTable("table.field-contacts-table", function($table, options) {
  $table.DataTable({
    ...options,
    columns: [
      {data: "fc_num", render: fc_num_renderer},
      {data: "contact_date", render: date_time_renderer},
      {data: "contact_officer_name", render: text_renderer},
      {data: "supervisor_name", render: text_renderer},
      {data: "street", render: text_renderer},
      {data: "city", render: text_renderer},
      {data: "state", render: text_renderer},
      {data: "zip", render: zip_renderer},
      {data: "frisked_searched", render: yes_no_renderer},
      {data: "stop_duration", render: int_renderer},
      {data: "circumstance", render: text_renderer},
      {data: "basis", render: text_renderer},
      {data: "vehicle_year", render: int_renderer},
      {data: "vehicle_state", render: text_renderer},
      {data: "vehicle_make", render: text_renderer},
      {data: "vehicle_model", render: text_renderer},
      {data: "vehicle_color", render: text_renderer},
      {data: "vehicle_style", render: text_renderer},
      {data: "vehicle_type", render: text_renderer},
      {data: "key_situations", render: see_more_renderer},
      {data: "weather", render: text_renderer},
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
  return `<div class="text-center"><a href="${row.url}">${escape(data)}</a></div>`;
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
