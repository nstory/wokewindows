import escape from "lodash/escape";
import {date_renderer, url_renderer, text_renderer} from "renderers";
import {initDataTable} from "shared/tables/common";

initDataTable("table.articles-table", function($table, options) {
  $table.DataTable({
    ...options,
    columns: [
      {data: "date_published", render: url_renderer(date_renderer)},
      {data: "source", render: url_renderer(text_renderer)},
      {data: "title", render: article_renderer},
    ],
    order: [[0, 'desc']]
  });
});

export function article_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data == null) {
    return unknown();
  }
  return `<a href="${escape(row.url)}">${escape(data)}</a><br><span class="text-muted">${escape(row.excerpt)}</span>`;
}

