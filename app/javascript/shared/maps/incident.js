import Leaflet from "leaflet";

$(document).on("turbolinks:load", function() {
  const $e = $("#incident-map");

  if (!$e.length) {
    return;
  }

  const latitude = $e.data("latitude");
  const longitude = $e.data("longitude");

  const map = Leaflet.map($e[0], {
    center: [42.325, -71.0762],
    zoom: 12
  });
  Leaflet.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
  }).addTo(map);
  // L.Icon.Default.prototype.options.imagePath = "/images/";
  // Leaflet.Icon.Default.prototype.options.iconUrl = "/images/marker-icon.png";
  const myIcon = Leaflet.icon({
    iconUrl:       '/images/marker-icon.png',
    iconRetinaUrl: '/images/marker-icon-2x.png',
    shadowUrl:     '/images/marker-shadow.png',
    iconSize:    [25, 41],
    iconAnchor:  [12, 41],
    popupAnchor: [1, -34],
    tooltipAnchor: [16, -28],
    shadowSize:  [41, 41]
  })

  Leaflet.marker([latitude, longitude], {icon: myIcon}).addTo(map);
  map.fitBounds([[latitude, longitude]], {maxZoom: 14});
});
