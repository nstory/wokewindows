class HelpController < ApplicationController
  include HighVoltage::StaticPage

  layout "help"

  def page_finder_factory
    PageFinder
  end

  class PageFinder < HighVoltage::PageFinder
    def content_path
      "help/"
    end
  end
end
