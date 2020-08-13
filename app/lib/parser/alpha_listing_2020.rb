# parses alpha_listing_20200715.csv file; maps field names to
# match those in previous alpha listing file
class Parser::AlphaListing2020 < Parser::Csv
  KEY_MAPPING = {
    idno6: :empl_id
  }

  def category
    "alpha_listing_20200715"
  end

  def map_key(key)
    KEY_MAPPING.fetch(key, key)
  end
end
