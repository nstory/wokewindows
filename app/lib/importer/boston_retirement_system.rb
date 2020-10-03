class Importer::BostonRetirementSystem < Importer::Importer
  def self.import_all
    parser = Parser::BostonRetirementSystem.new("data/boston_retirement_system_20200909.csv.gz")
    new(parser).import
  end

  def import
    Pension.transaction do
      Pension.delete_all
      records.each do |r|
        import_record(r) if r[:department] == "BOSTON POLICE DEPARTMENT - 211000"
      end
    end
  end

  private
  def import_record(record)
    Pension.create(
      name: parse_string(record[:sort_name]),
      amount: parse_money(record[:gross_amount]),
      retirement_date: parse_date(record[:retirement_date]),
      department: parse_string(record[:department]),
      job_description: parse_string(record[:job_description]),
      officer: find_officer(record[:sort_name], record[:job_description]),
      attributions: [attribution]
    )
  end

  def find_officer(sort_name, job_description)
    hr_name = sort_name.sub(/, +/, ",")
    os = Officer.where("hr_name ILIKE ?", hr_name)
      .reject(&:active)
      .select { |o| o.title && job_description.start_with?(o.title) }
    raise "multiple officers" if os.count > 1
    os.first
  end
end
