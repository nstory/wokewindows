import escape from "lodash/escape";
import {date_renderer, url_renderer, text_renderer} from "renderers";
import {initDataTable} from "shared/tables/common";

initDataTable("table.articles-table", function($table, options) {
  $table.DataTable({
    ...options,
    columns: [
      // {data: "article_url", render: article_url_renderer, orderable: false},
      {data: "date_published", render: date_published_renderer},
      {data: "source", render: url_renderer(text_renderer)},
      {data: "title", render: article_renderer},
    ],
    order: [[1, 'desc']]
  });
});

export function date_published_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  const date = date_renderer(data, type, row)
  const article_url = row.article_url;
  let ret = `<a href="${escape(row.url)}">${date}</a>`;
  if (article_url) {
    ret = `<a href="${escape(row.article_url)}">Edit</a> <span class="text-muted">|</span> ` + ret;
  }
  return ret;
}

export function article_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data == null) {
    return unknown();
  }
  return `<a href="${escape(row.url)}">${escape(data)}</a><br><span class="text-muted">${escape(row.excerpt)}</span>`;
}

export function article_url_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data == null) {
    return unknown();
  }
  return `<a href="${escape(row.article_url)}">Edit</a>`;
}
