class Parser::Cy2015AnnualEarnings < Parser::Csv
  def filter(record)
    !record[:empl_id].blank?
  end
end
