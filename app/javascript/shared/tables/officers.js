import escape from "lodash/escape";
import {int_renderer, employee_id_renderer, employee_name_renderer, earnings_renderer, date_renderer, zip_renderer, text_renderer} from "renderers";
import {initDataTable} from "shared/tables/common";

initDataTable("table.officers-table", function($table, options) {
  $table.DataTable({
    ...options,
    columns: [
      {data: "employee_id", render: employee_id_renderer},
      {data: "name", render: employee_name_renderer},
      {data: "title", render: text_renderer},
      {data: "doa", render: date_renderer},
      {data: "postal", render: zip_renderer},
      {data: "state", render: text_renderer},
      {data: "neighborhood", render: text_renderer, orderable: false},
      {data: "complaints_count", render: int_with_link_renderer("complaints")},
      {data: "details_count", render: int_with_link_renderer("details")},
      {data: "field_contacts_count", render: int_with_link_renderer("field_contacts")},
      {data: "incidents_count", render: int_with_link_renderer("incidents")},
      {data: "swats_count", render: int_with_link_renderer("swats")},
      {data: "total", render: earnings_renderer},
      {data: "regular", render: earnings_renderer},
      {data: "retro", render: earnings_renderer},
      {data: "other", render: earnings_renderer},
      {data: "overtime", render: earnings_renderer},
      {data: "injured", render: earnings_renderer},
      {data: "detail", render: earnings_renderer},
      {data: "quinn", render: earnings_renderer},
    ],
    order: [[11, 'desc']]
  });
});

function int_with_link_renderer(fragment) {
  return (data, type, row) => {
    if (type != "display") {
      return data;
    }
    if (data == null) {
      return `<div class="text-center">${unknown()}</div>`;
    }
    return `<div class="text-center"><a href="${escape(row['url'])}#${fragment}">${escape(data)}</a></div>`;
  };
}
