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
    return '<span class="unknown">Unknown</span>';
  }
  return `<span class="text-monospace">${data}</span>`;
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
