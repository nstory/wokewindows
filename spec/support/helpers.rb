module Helpers
  def mock_parser(records, attribution = nil)
    attribution ||= Attribution.new(filename: "a", category: "b", url: "c")
    OpenStruct.new records: records, attribution: attribution
  end
end
