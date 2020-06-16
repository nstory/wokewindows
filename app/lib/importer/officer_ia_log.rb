# imports data from data/2014_Officer__IA_Log_redacted.csv
# records already in the database are skipped
class Importer::OfficerIaLog
  def self.import_all
    parser = Parser::OfficerIaLog.new(
      "data/2014_Officer__IA_Log_redacted.csv"
    )
    import(parser.records)
  end

  def self.import(records)
    Complaint.transaction do
      records.each do |record|
        attr = map_complaint(record)
        begin
          Complaint.create(attr)
        rescue ActiveRecord::RecordNotUnique
          # ignore
        end
      end
    end
  end

  private
  def self.map_complaint(record)
    {
      # generate an ia number for the few cases where we didn't get one
      ia_number: record[:ia_no].blank? ? "unknown-#{record.hash}" : record[:ia_no],
      received_date: parse_date(record[:date_received]),
      occurred_date: parse_date(record[:date_occurred]),
      incident_type: parse_string(record[:incident_type]),
      complaint_officers: map_complaint_officers(record),
      summary: parse_string(record[:summary])
    }
  end

  def self.map_complaint_officers(record)
    lines = record[:involved_officers].split(/\n+/m)
    lines.reject(&:blank?).map do |line|
      ComplaintOfficer.new({ name: line.strip })
    end
  end

  def self.parse_string(str)
    str.blank? ? nil : str
  end

  def self.parse_date(date)
    time = Chronic.parse(date)
    time ? time.strftime("%F") : nil
  end
end
