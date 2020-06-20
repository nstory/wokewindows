class Parser::AlphaListing < Parser::Csv
  MAPPING = {
    idno6: :empl_id
  }

  def category
    "alpha_listing"
  end

  def map_key(key)
    MAPPING.fetch(key, key)
  end
end
