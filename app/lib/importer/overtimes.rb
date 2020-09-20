class Importer::Overtimes < Importer::Importer

  def self.import_all
    parser = Parser::CourtOvertime.new("data/court_overtime_2014_2019.csv.gz")
    new(parser).import
  end

  def import
    @officer_by_employee_id = Officer.by_employee_id
    Overtime.transaction do
      Overtime.destroy_all
      records.each { |r| import_record(r) }
    end
  end

  private
  def import_record(record)
    Overtime.create({
      employee_id: parse_int(record[:id]),
      officer: @officer_by_employee_id[parse_int(record[:id])],
      name: parse_string(record[:name]),
      rank: parse_string(record[:rank]),
      assigned: parse_string(record[:assigned]),
      charged: parse_string(record[:charged]),
      date: parse_date(record[:otdate]),
      code: parse_int(record[:otcode]),
      description: parse_string(record[:description]),
      start_time: parse_string(record[:starttime]),
      end_time: parse_string(record[:endtime]),
      worked_hours: parse_float(record[:wrkdhrs]),
      ot_hours: parse_float(record[:othours]),
      attributions: [attribution]
    })
  end
end
