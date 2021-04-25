import Chart from "chart.js";
import find from "lodash/find";
import range from "lodash/range";
import {Controller} from "stimulus";

export default class CompensationsChartController extends Controller {
  static targets = ["canvas"];

  connect() {
    this.chart = this.createChart(this.canvasTarget, this.getChartData());
  }

  disconnect() {
    if (this.chart) {
      this.chart.destroy();
    }
  }

  getChartData() {
    return JSON.parse(this.data.get("data"));
  }

  createChart($chart, compensations) {
    const years = range(2011, 2021);
    const currencyFormat = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' });

    function getData(type) {
      return years.map((year) => (find(compensations, {year}) || {})[type])
    }

    return new Chart($chart, {
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
}
