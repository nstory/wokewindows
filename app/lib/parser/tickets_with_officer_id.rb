class Parser::TicketsWithOfficerId < Parser::Csv
  MAPPING = {
    :"16_pass_" => :"16_pass"
  }

  def category
    "2019_tickets"
  end

  def map_key(key)
    MAPPING.fetch(key, key)
  end
end
