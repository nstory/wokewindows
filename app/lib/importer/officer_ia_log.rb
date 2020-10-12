# imports data from data/2014_Officer__IA_Log_redacted.csv
# does not import new records; only updates summaries
class Importer::OfficerIaLog < Importer::Importer
  def self.import_all
    parser = Parser::OfficerIaLog.new(
      "data/2014_Officer__IA_Log_redacted.csv.gz"
    )
    new(parser).import
  end

  def import
    records.each do |record|
      complaint = Complaint.find_by(ia_number: record[:ia_no])
      if complaint
        complaint.summary = parse_string(record[:summary])
        complaint.add_attribution(attribution)
        complaint.save
      end
    end
  end
end
