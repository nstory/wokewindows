import { Controller } from "stimulus";

export default class OfficerSelectController extends Controller {
  connect() {
    $(this.element).select2({
      ajax: {
        url: "/officers/select2",
        dataType: "json"
      }
    });
  }

  disconnect() {
    $(this.element).select2("destroy");
  }
}
