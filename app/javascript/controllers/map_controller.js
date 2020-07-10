import Leaflet from "leaflet";
import {Controller} from "stimulus";

export default class MapController extends Controller {
  connect() {
    const latitude = this.data.get("latitude");
    const longitude = this.data.get("longitude");

    if (!latitude || !longitude) {
      return;
    }

    // place map in the <div> this controller was initialized one
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
}
