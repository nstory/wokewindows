import Chart from "chart.js";
import find from "lodash/find";
import range from "lodash/range";
import {earnings_renderer, zip_renderer} from "renderers";

// corresponding javascript for shared/_compensations_table.html.erb
$(document).on("turbolinks:load", function() {
  $("table.compensations-table").each(function() {
    const $table = $(this);
    const id = $table.attr("data-id");
    const data = window[id];
    const $chart = $(`canvas[data-id="${id}"]`)

    chart($chart, data);
    dataTable($table, data);
  });
});

function chart($chart, compensations) {
  const years = range(2011, 2020);
  const currencyFormat = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' });

  function getData(type) {
    return years.map((year) => (find(compensations, {year}) || {})[type])
  }

  const chart = new Chart($chart, {
    type: "bar",
    data: {
      labels: years,
      datasets: [
        {
          label: "Regular Pay",
          data: getData("regular"),
          backgroundColor: "black"
        },
        {
          label: "Retro",
          data: getData("retro"),
          backgroundColor: "pink"
        },
        {
          label: "Other",
          data: getData("other"),
          backgroundColor: "gray"
        },
        {
          label: "Overtime",
          data: getData("overtime"),
          backgroundColor: "red"
        },
        {
          label: "Injured",
          data: getData("injured"),
          backgroundColor: "purple"
        },
        {
          label: "Detail",
          data: getData("detail"),
          backgroundColor: "blue"
        },
        {
          label: "Quinn",
          data: getData("quinn"),
          backgroundColor: "green"
        }
      ]
    },
    options: {
      scales: {
        xAxes: [{
          stacked: true
        }],
        yAxes: [{
          stacked: true,
          ticks: {
            beginAtZero: true,
            callback: function(value, index, values) {
              return currencyFormat.format(value);
            }
          }
        }]
      },
      tooltips: {
        callbacks: {
          label: function(tooltipItem, data) {
            var label = data.datasets[tooltipItem.datasetIndex].label || '';
            label += ': ';
            label += currencyFormat.format(tooltipItem.yLabel);
            return label;
          },
          afterBody: function(tooltipItem, data) {
            const year = tooltipItem[0].xLabel;
            const comp = find(compensations, {year});
            if (comp) {
              return `Total Earnings ${year}: ${currencyFormat.format(comp.total)}`;
            }
          }
        }
      }
    }
  });
}

function dataTable($table, data) {
  $table.DataTable({
    data: data,
    columns: [
      {data: "year"},
      {data: "name"},
      {data: "department_name"},
      {data: "title"},
      {data: "regular", render: earnings_with_pct_renderer},
      {data: "retro", render: earnings_with_pct_renderer},
      {data: "other", render: earnings_with_pct_renderer},
      {data: "overtime", render: earnings_with_pct_renderer},
      {data: "injured", render: earnings_with_pct_renderer},
      {data: "detail", render: earnings_with_pct_renderer},
      {data: "quinn", render: earnings_with_pct_renderer},
      {data: "total", render: earnings_with_pct_renderer},
      {data: "postal", render: zip_renderer}
    ],
    info: false,
    order: [[0, 'desc']],
    paging: false,
    searching: false,
    scrollX: true
  });
}

const currency_format = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' });

function earnings_with_pct_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data) {
    const pct = Math.floor(data/row['total']*100) + "%";
    return `<div class="earnings"><span class="earnings__dollars">${currency_format.format(data)}</span> <span class="earnings__pct">${pct}</span></div>`;
  }
  return '<div style="text-align:center">-</div>';
}
