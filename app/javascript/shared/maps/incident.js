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
  const colors = ["#800000", "#ff0000", "#800080", "#ff00ff", "#008000", "#ff7f50", "#808000", "#00008b", "#000080", "#0000ff", "#008080", "#00ffff"];
  let colorIndex = 0;

  $.getJSON("/districts_geojson.json", function(data) {
    const geoJson = Leaflet.geoJSON(
      data, {
        style: function(feature) {
          const color = colors[colorIndex];
          colorIndex = (colorIndex + 1) % colors.length;
          return {color, fill: false, dashArray: `${colorIndex+5} ${colorIndex+6}`};
        }
      }
    );
    geoJson.addTo(map);
    geoJson.getLayers().forEach((layer) => {
      const district = layer.feature.properties.DISTRICT;
      layer.bindTooltip(district, {permanent: true}).openTooltip();
    });
  });
});
