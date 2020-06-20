module Helpers
  def mock_parser(records, attribution)
    OpenStruct.new records: records, attribution: attribution
  end
end
