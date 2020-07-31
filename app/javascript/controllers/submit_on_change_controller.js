import {Controller} from "stimulus";
import Rails from "jquery-ujs";

export default class SubmitOnChangeController extends Controller {
  connect() {
    $(this.element).on("change", this._submit);
    this._$form().on("ajax:success", this._ajaxSuccess);
  }

  disconnect() {
    $(this.element).off("change", this._submit);
    this._$form().off("ajax:success", this._ajaxSuccess);
    this._$form().off("ajax:error", this._ajaxError);
  }

  _$form() {
    return $(this.element).closest("form");
  }

  _submit = () => {
    this._$form().submit();
    $(this.element).prop("disabled", true);
  }

  _ajaxSuccess = (ev) => {
    $(this.element).prop("disabled", false);
  }

  _ajaxError = (ev) => {
    $(this.element).prop("disabled", false);
    alert("An error occurred submitting your change. Please reload the page and try again.");
  }
}
