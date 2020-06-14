class Parser::AlphaListing < Parser::Csv
  MAPPING = {
    idno6: :empl_id
  }

  def map_key(key)
    MAPPING.fetch(key, key)
  end
end
