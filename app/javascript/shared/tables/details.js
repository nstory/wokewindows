import escape from "lodash/escape";
import padStart from "lodash/padStart";
import {date_time_renderer, earnings_renderer, text_renderer, url_renderer} from "renderers";
import {initDataTable} from "shared/tables/common";

initDataTable("table.details-table", function($table, options) {
  $table.DataTable({
    ...options,
    columns: [
      {data: "tracking_no", render: url_renderer(text_renderer)},
      {data: "employee_name", render: text_renderer},
      {data: "detail_type", render: text_renderer},
      {data: "customer_name", render: text_renderer},
      {data: "address", render: text_renderer},
      {data: "start_date_time", render: date_time_renderer},
      {data: "minutes_worked", render: minutes_renderer},
      {data: "pay_amount", render: earnings_renderer},
    ],
    order: [[0, 'desc']]
  });
});

export function minutes_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data == null) {
    return `<div class="text-center">${unknown()}</div>`;
  }
  const hours = Math.floor(data / 60);
  const minutes = data % 60;
  const text = `${hours}:${padStart(minutes, 2, '0')}`;
  return `<div class="text-center" title="${hours} hours ${minutes} minutes">${escape(text)}</div>`;
}

