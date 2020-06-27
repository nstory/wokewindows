# imports data from data/2014_Officer__IA_Log_redacted.csv
# if a record is already in the database, this will only add the summary
class Importer::OfficerIaLog < Importer::Importer
  def self.import_all
    parser = Parser::OfficerIaLog.new(
      "data/2014_Officer__IA_Log_redacted.csv.gz"
    )
    new(parser).import
  end

  def import
    by_ia_number = complaints_by_number(records.pluck(:ia_no))

    records.each do |record|
      attr = map_complaint(record)
      complaint = by_ia_number[record[:ia_no]]
      if complaint.persisted?
        # update existing record
        complaint.summary = attr[:summary]
        complaint.add_attribution(attribution)
      else
        # new record
        complaint.attributes = attr
      end
      complaint.save
    end
  end

  private
  def map_complaint(record)
    {
      # generate an ia number for the few cases where we didn't get one
      ia_number: record[:ia_no].blank? ? "unknown-#{record.hash}" : record[:ia_no],
      received_date: parse_date(record[:date_received]),
      occurred_date: parse_date(record[:date_occurred]),
      incident_type: parse_string(record[:incident_type]),
      complaint_officers: map_complaint_officers(record),
      summary: parse_string(record[:summary]),
      attributions: [attribution]
    }
  end

  def map_complaint_officers(record)
    lines = record[:involved_officers].split(/\n+/m)
    lines.reject(&:blank?).map do |line|
      ComplaintOfficer.new({ name: line.strip })
    end
  end
end
