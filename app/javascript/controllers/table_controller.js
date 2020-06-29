import debounce from "lodash/debounce";
import { Controller } from "stimulus";

const DEBOUNCE_TIME_MS = 500;

export default class TableController extends Controller {
  static targets = ["searchInput", "downloadButton"];

  initialize() {
    this._performSearch = debounce(this._performSearch, DEBOUNCE_TIME_MS);
  }

  download(ev) {
    // get CSV url and params from the datatable
    const url = this._dataTable().ajax.url().replace(/\.json$/, ".csv")
    const params = this._dataTable().ajax.params();

    // temporarily disable the download button so user doesn't accidentally DOS us
    this.downloadButtonTarget.disabled = true;
    setTimeout(() => this.downloadButtonTarget.disabled = false, 5000);

    // send the user to the CSV file; this will cause the browser to download it
    $.redirect(url, params, "POST");
  }

  search(ev) {
    const query = this.searchInputTarget.value;

    // show the loading indicator over the table
    this._$wrapper().addClass("search-queued");

    this._performSearch(query);
  }

  _performSearch(query) {
    this._$wrapper().removeClass("search-queued");
    this._dataTable().search(query);
    this._dataTable().draw();
  }

  _dataTable() {
    return this._$table().dataTable().api();
  }

  _$table() {
    return $(this.element).find("table");
  }

  _$wrapper() {
    return this._$table().closest(".dataTables_wrapper");
  }
}
