import tocbot from "tocbot";

$(document).on("turbolinks:load", function() {
  tocbot.init({
    tocSelector: ".toc",
    hasInnerContainers: true,
    scrollSmooth: false,
    collapseDepth: 6
  });
});
