import escape from "lodash/escape";
import moment from "moment";

export function employee_id_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  const six_digit = ("000000" + data).slice(-6);
  return `<a href="${row.url}">${six_digit}</a>`;
}

export function employee_name_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  return `<a href="${row.url}">${data}</a>`;
}

const currency_format = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' });

export function earnings_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data) {
    return `<div class="earnings"><span class="earnings__dollars">${currency_format.format(data)}</span></div>`;
  }
  return '<div style="text-align:center">-</div>';
}

export function date_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (!data) {
    return '<span class="unknown">N/A</span>';
  }
  return moment(data).format("MMM D, YYYY");
}

export function date_time_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (!data) {
    return '<span class="unknown">N/A</span>';
  }
  return moment(data).format("MMM D, YYYY h:mm a");
}

export function zip_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (!data) {
    return "";
  }
  return ("00000" + data).slice(-5);
}

// renders data as-is unless it's null, then this renders N/A
export function na_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data == null) {
    return '<span class="unknown">N/A</span>';
  }
  return `<span>${escape(data)}</span>`;
}

export function int_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data == null) {
    return '<span class="unknown">N/A</span>';
  }
  return `<div class="text-center">${escape(data)}</div>`;
}
