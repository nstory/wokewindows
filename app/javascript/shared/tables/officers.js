import escape from "lodash/escape";
import padStart from "lodash/padStart";
import {int_renderer, employee_id_renderer, employee_name_renderer, earnings_renderer, date_renderer, zip_renderer, text_renderer, title_renderer, unknown} from "renderers";
import {initDataTable} from "shared/tables/common";

initDataTable("table.officers-table", function($table, options) {
  $table.DataTable({
    ...options,
    columns: [
      {data: "employee_id", render: employee_id_renderer},
      {data: "badge", render: badge_renderer, orderable: false},
      {data: "name", render: employee_name_renderer},
      {data: "title", render: text_renderer},
      {data: "organization", render: title_renderer},
      {data: "doa", render: date_renderer},
      {data: "postal", render: zip_renderer},
      {data: "state", render: text_renderer},
      {data: "neighborhood", render: text_renderer, orderable: false},
      {data: "articles_officers_count", render: articles_officers_count_renderer},
      {data: "ia_score", render: ia_score_renderer},
      {data: "details_count", render: int_with_link_renderer("details")},
      {data: "field_contacts_count", render: int_with_link_renderer("field_contacts")},
      {data: "incidents_count", render: int_with_link_renderer("incidents")},
      {data: "citations_count", render: int_with_link_renderer("citations")},
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
    order: [[16, 'desc']]
  });
});

function badge_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data == null) {
    return unknown();
  }
  if (/^\d+$/.test(data)) {
    data = padStart(data, 5, "0");
  }
  return data;
}

function ia_score_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data == null) {
    return `<div class="text-center">${unknown()}</div>`;
  }
  return `<div class="text-center"><a class="officer__ia-score-${data}" href="${escape(row['url'])}#complaints">${escape(data)}</a></div>`;
}

function articles_officers_count_renderer(data, type, row) {
  let ret =  `<a href="${escape(row['url'])}#articles">${escape(data)}</a>`;
  if (row.articles_officers_to_review_count) {
    ret = `${ret} <span class="text-muted"> / ${row.articles_officers_to_review_count}</span>`;
  }
  ret = `<div class="text-center">${ret}</div>`;
  return ret;
}

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
