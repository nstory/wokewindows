class DataSourcesController < ApplicationController
  include HighVoltage::StaticPage

  layout "data_source"

  def index
    @data_sources = DataSource.all
    render :index, layout: "application"
  end

  def show
    @data_source = DataSource.find(params[:id])
    super
  end

  def page_finder_factory
    PageFinder
  end

  class PageFinder < HighVoltage::PageFinder
    def content_path
      "data_sources/"
    end
  end
end
