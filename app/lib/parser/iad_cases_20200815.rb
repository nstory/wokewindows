class Parser::IadCases20200815 < Parser::Csv
  KEY_MAPPING = {
    title_rank_snap_: :title,
  }

  def category
    "iad_cases_20200815"
  end

  def map_key(key)
    KEY_MAPPING.fetch(key, key)
  end
end
