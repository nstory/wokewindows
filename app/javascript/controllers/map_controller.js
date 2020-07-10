import Leaflet from "leaflet";
import {Controller} from "stimulus";

export default class MapController extends Controller {
  connect() {
    const latitude = this.data.get("latitude");
    const longitude = this.data.get("longitude");

    if (!latitude || !longitude) {
      return;
    }

    // place map in the <div> this controller was initialized on
    const map = Leaflet.map(this.element, {
      center: [latitude, longitude],
      zoom: 14
    });

    // use OpenStreetMap
    Leaflet.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

    Leaflet.marker([latitude, longitude], {icon: this._icon()}).addTo(map);
  }

  _icon() {
    return Leaflet.icon({
      iconUrl:       '/images/marker-icon.png',
      iconRetinaUrl: '/images/marker-icon-2x.png',
      shadowUrl:     '/images/marker-shadow.png',
      iconSize:    [25, 41],
      iconAnchor:  [12, 41],
      popupAnchor: [1, -34],
      tooltipAnchor: [16, -28],
      shadowSize:  [41, 41]
    });
  }

  _districts(map) {
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
  }
}
