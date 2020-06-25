import Chart from "chart.js";
import find from "lodash/find";
import range from "lodash/range";

// corresponding javascript for shared/_compensations_table.html.erb
$(document).on("turbolinks:load", function() {
  $(".compensations-chart").each(function() {
    const $chart = $(this);
    const id = $chart.attr("data-id");
    const data = window[id];
    chart($chart, data);
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
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        xAxes: [{
          stacked: true
        }],
        yAxes: [{
          stacked: true,
          ticks: {
            beginAtZero: true,
            suggestedMax: 100000,
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
