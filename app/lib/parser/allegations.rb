# for parsing the 2010_to_2020_allegations.csv file
class Parser::Allegations < Parser::Csv
  KEY_MAPPING = {
    title_rank_snap_: :title,
    completed_date: :finding_date,
    disposition: :finding
  }

  def category
    "allegations_2010_to_2020"
  end

  def map_key(key)
    KEY_MAPPING.fetch(key, key)
  end
end
