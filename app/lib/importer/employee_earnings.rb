class Importer::EmployeeEarnings < Importer::Importer
  def self.import_all
    parser = Parser::Csv.new(ENV.fetch('EARNINGS_CSV'), 'employee_earnings')
    new(parser).import
  end

  def import
    @officer_by_employee_id = Officer.by_employee_id
    Compensation.transaction do
      Compensation.delete_all
      records.select { |r| r[:department_name] =~ /^Boston Police/i }
        .each { |record| import_record(record) }
    end
  end

  def import_record(record)
    Compensation.create({
      name: record[:name],
      department_name: record[:department_name],
      title: record[:title],
      regular: parse_money(record[:regular]),
      retro: parse_money(record[:retro]),
      other: parse_money(record[:other]),
      overtime: parse_money(record[:overtime]),
      injured: parse_money(record[:injured]),
      detail: parse_money(record[:detail]),
      quinn: parse_money(record[:quinn]),
      total: parse_money(record[:total_earnings]),
      postal: parse_int(record[:postal]),
      year: record[:year],
      attributions: [attribution],
      officer: @officer_by_employee_id[record[:employee_id].to_i]
    })
  end
end
