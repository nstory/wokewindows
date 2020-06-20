class Parser::Cy2015AnnualEarnings < Parser::Csv
  def category
    "cy2015_annual_earnings"
  end

  def filter(record)
    !record[:empl_id].blank?
  end
end
