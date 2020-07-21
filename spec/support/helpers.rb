module Helpers
  def mock_parser(records, attribution = nil)
    attribution ||= Attribution.new(filename: "a", category: "b", url: "c")
    OpenStruct.new records: records, attribution: attribution
  end

  def assert_canonical_link(regexp)
    link = page.find("link[rel=canonical]", visible: false)
    expect(link["href"]).to match(regexp)
  end

  def assert_meta_description(regexp)
    desc = page.find("meta[name=description]", visible: false)
    expect(desc['content']).to match(regexp)
  end
end
