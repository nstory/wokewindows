# DataSources are stored in app/views/data_sources with attributes taken from
# the "front matter" of each page -- i'm probably being too creative here.
class DataSource
  include ActiveAttr::Model

  attribute :id, type: String
  attribute :title, type: String
  attribute :date, type: Date
  attribute :description, type: String
  attribute :status, type: String
  attribute :links

  def self.all
    pc = HighVoltage::PageCollector.new("app/views/data_sources/")

    # i'm cheating by calling a private method
    pages = pc.send(:pages)
      .select(&:valid?)
      .reject { |p| p.id == "index" }

    pages.map do |page|
      id = page.id
      fm = FrontMatterParser::Parser.parse_file(page.file_path)
      DataSource.new(fm.front_matter.merge(id: id))
    end
  end

  def self.find(id)
    data_source = all.find { |ds| ds.id == id }
    raise ActiveRecord::RecordNotFound if !data_source
    data_source
  end
end
