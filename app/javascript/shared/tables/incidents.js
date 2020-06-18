import escape from "lodash/escape";
import extend from "lodash/extend";
import template from "lodash/template";
import {date_time_renderer, na_renderer} from "renderers";

$(document).on("turbolinks:load", function() {
  const $table = $("table.incidents-table");
  const dataTable = $table.DataTable({
    ajax: {
      url: "/incidents.json",
      dataSrc: "incidents"
    },
    dom: 'Bfrtip',
    buttons: [
      'csvHtml5'
    ],
    columns: [
      // {data: null, className: "incidents-table__toggle", orderable: false,  defaultContent: "+"},
      {data: "incident_number", orderable: false},
      {data: "occurred_on_date", render: date_time_renderer},
      {data: "district", orderable: false},
      {data: "shooting", render: shooting_renderer, orderable: false},
      {data: "location", orderable: false},
      {data: "nature_of_incident", render: array_renderer, orderable: false},
      {data: "incident_officers", render: officers_renderer, orderable: false},
      {data: null, render: trick_renderer}
    ],
    order: [[1, 'desc']],
    processing: true,
    responsive: {
      details: {
        display: $.fn.dataTable.Responsive.display.childRowImmediate,
        type: 'none',
        target: '',
        renderer: child_renderer
      }
    },
    // scrollX: true,
    searchDelay: 2000,
    serverSide: true
  })
});

function shooting_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data == null) {
    return '<span class="unknown">N/A</span>';
  }
  return data ? '<span class="text-danger">Y</span>' : '<span class="text-muted">N</span>';
}

function array_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data == null) {
    return "";
  }
  return data.map((v) => escape(v)).join("; ");
}

function officers_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data == null) {
    return '<span class="unknown">N/A</span>';
  }
  return data.map((o) => {
    if (o.url) {
      return `<a href="${escape(o.url)}">${o.name}</a>`;
    }
    return `<span>${o.name}</span>`;
  }).join(", ");
}

// tricks the responsive plugin into always showing a child row
function trick_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  return '<div style="width:9999px"></div>';
}

const child_template = template(`
  <div class="incidents-table__details">
    <div class="row">
      <div class="col">
        <dl class="row">
          <dt>District</dt>
          <dd><%= format_na(district) %></dd>

          <dt title="Reporting Area">Rpt Area</dt>
          <dd><%= format_na(reporting_area) %></dd>

          <dt>Officers</dt>
          <dd><%= format_officers(incident_officers) %></dd>

          <dt>Location</dt>
          <dd><%= format_na(location_of_occurrence[0]) %></dd>

          <dt>Street</dt>
          <dd><%= format_na(street) %></dd>

          <dt>Reported</dt>
          <dd><%= format_date_time(report_date) %></dd>

          <dt>Incident</dt>
          <dd><%= format_na(nature_of_incident[0]) %></dd>
        </dl>
      </div>
      <div class="col">
        <div><strong>Arrests</strong></div>
        <% if (arrests.length == 0) { %>
          <%= format_na(null) %>
        <% } %>
        <% arrests.forEach(function(arrest) { %>
          <div><%- arrest.name %> - <%- arrest.charge %></div>
        <% }) %>
      </div>
      <div class="col">
        <div><strong>Offenses</strong></div>
        <% if (offenses.length == 0) { %>
          <%= format_na(null) %>
        <% } %>
        <% offenses.forEach(function(offense) { %>
          <div><%= format_na(offense.code) %> - <%= format_na(offense.code_group) %> - <%= format_na(offense.description) %></div>
        <% }) %>
      </div>
    </div>
  </div>
`);

function helperify(renderer) {
  return (data) => renderer(data, "display", {});
}

function child_renderer(api, rowIdx, columns) {
  const helpers = {
    format_date_time: helperify(date_time_renderer),
    format_na: helperify(na_renderer),
    format_officers: helperify(officers_renderer)
  }
  const data = api.row(rowIdx).data();
  return child_template(extend({}, data, helpers));
}
