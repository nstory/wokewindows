import tocbot from "tocbot";

$(document).on("turbolinks:load", function() {
  if ($(".toc").length) {
    tocbot.init({
      tocSelector: ".toc",
      hasInnerContainers: true,
      scrollSmooth: false,
      collapseDepth: 6
    });
  }
});
