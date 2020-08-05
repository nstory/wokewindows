import uniqueId from "lodash/uniqueId";
import {Controller} from "stimulus";
import tocbot from "tocbot";

export default class TocController extends Controller {
  connect() {
    // need to pass a selector to tocbot, so give the element a unique id
    // so it will have a unique selector
    const id = uniqueId("toc_controller");
    this.element.id = id;

    tocbot.init({
      tocSelector: `#${id}`,
      hasInnerContainers: true,
      scrollSmooth: false,
      collapseDepth: 1
    });
  }

  disconnect() {
    // tell tocbot to remove its event listeners (including scroll listiners on
    // document); skipRendering means it doesn't empty the toc div; turbolinks
    // removes all the html on the page, so, no need
    tocbot.options.skipRendering = true;
    tocbot.destroy();
  }
}
