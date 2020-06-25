import debounce from "lodash/debounce";
import { Controller } from "stimulus";

const DEBOUNCE_TIME_MS = 500;

export default class TableSearchController extends Controller {
  initialize() {
    this._performSearch = debounce(this._performSearch, DEBOUNCE_TIME_MS);
  }

  search(ev) {
    const query = $(this.element).val();
    this.$wrapper().addClass("search-queued");
    this._performSearch(query);
  }

  _performSearch(query) {
    this.$wrapper().removeClass("search-queued");
    this._dataTable().search(query);
    this._dataTable().draw();
  }

  _dataTable() {
    return this.$table().dataTable().api();
  }

  $table() {
    return $("table");
  }

  $wrapper() {
    return this.$table().closest(".dataTables_wrapper");
  }
}
