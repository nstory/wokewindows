import escape from "lodash/escape";
import {date_renderer, url_renderer, text_renderer} from "renderers";
import {initDataTable} from "shared/tables/common";

initDataTable("table.articles-table", function($table, options) {
  $table.DataTable({
    ...options,
    columns: [
      {data: "date_published", render: date_renderer},
      {data: "source", render: text_renderer, orderable: false},
      {data: "title", render: url_renderer(text_renderer)},
    ],
    order: [[0, 'desc']]
  });
});

