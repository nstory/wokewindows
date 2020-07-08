import escape from "lodash/escape";
import moment from "moment";

export function unknown() {
   return '<span class="unknown">N/A</span>';
}

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
export function text_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data == null) {
    return unknown();
  }
  return `<span>${escape(data)}</span>`;
}

export function int_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data == null) {
    return `<div class="text-center">${unknown()}</div>`;
  }
  return `<div class="text-center">${escape(data)}</div>`;
}

export function array_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data == null) {
    return '<span class="unknown">N/A</span>';
  }
  return data.map((v) => escape(v)).join(", ");
}

export function see_more_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data == null) {
    return unknown();
  }
  let text = "";
  if (data[0]) {
    text += escape(data[0]);
  }
  if (data.length > 1) {
    text += ` <a href="${escape(row.url)}">(${data.length} total)</a>`;
  }
  return text;
}

export function yes_no_renderer(data, type, row) {
  if (type != "display") {
    return data;
  }
  if (data == null) {
    return  `<div class="text-center">${unknown()}</div>`;
  }
  return `<div class="text-center">${data ? 'Y' : '<span class="text-muted">N</span>'}</div>`;
}

export function url_renderer(r) {
  return (data, type, row) => {
    if (type != "display") {
      return data;
    }
    if (data == null) {
      return  `<div class="text-center">${unknown()}</div>`;
    }
    return `<a href="${row.url}">${r(data, type, row)}</a>`;
  };
}
