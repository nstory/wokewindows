class Importer::Forfeiture::Superior < Importer::Forfeiture::Forfeiture
  def court
    "superior"
  end

  def parse_case_number(case_number)
    if /^(\d{4})-(\d+)/.match(case_number)
      year = $1
      num = $2
      return "#{year.to_i - 2000}84CV#{num.rjust(5, "0")}"
    end

    if case_number.gsub("-", "").length == 11
      return case_number.gsub("-", "")
    end

    nil
  end
end
