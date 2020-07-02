class Importer::Forfeiture::Bmc < Importer::Forfeiture::Forfeiture
  def parse_case_number(case_number)
    if /^(\d{2})-(\d+)/.match(case_number)
      year = $1
      num = $2
      return "#{year.rjust(2, "0")}#{court_code}CR#{num.rjust(6, "0")}"
    end
    nil
  end
end
