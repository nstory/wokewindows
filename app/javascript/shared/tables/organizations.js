import escape from "lodash/escape";
import {text_renderer, int_renderer} from "renderers"
import {initDataTable} from "shared/tables/common";

initDataTable("table.organizations-table", function($table, options) {
  $table.DataTable({
    ...options,
    ordering: false,
    columns: [
      {data: "organization", render: organization_name_renderer},
      {data: "num_employees", render: int_renderer},
    ]
  });
});

function organization_name_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (!data) {
    return "";
  }
  return `<a href="${row.url}">${escape(data)}</a>`
}