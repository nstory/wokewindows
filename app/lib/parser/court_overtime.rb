class Parser::CourtOvertime < Parser::Csv
  def category
    "court_overtime"
  end

  def filter(record)
    # skip total rows
    !record[:id].blank?
  end
end
