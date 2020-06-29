import debounce from "lodash/debounce";
import { Controller } from "stimulus";

const DEBOUNCE_TIME_MS = 500;

export default class TableController extends Controller {
  static targets = ["searchInput"];

  initialize() {
    this._performSearch = debounce(this._performSearch, DEBOUNCE_TIME_MS);
  }

  download(ev) {
    const url = this._dataTable().ajax.url().replace(/\.json$/, ".csv")
    const params = this._dataTable().ajax.params();
    $.redirect(url, params, "POST");
  }

  search(ev) {
    const query = this.searchInputTarget.value;
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
