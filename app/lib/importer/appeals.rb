class Importer::Appeals < Importer::Importer
  SLICE_SIZE = 1000

  def self.import_all
    new(
      Parser::Appeals.new("data/appeals.jsonl.gz")
    ).import
  end

  def import
    records.each_slice(SLICE_SIZE).each do |slice|
      Appeal.transaction do
        import_slice(slice)
      end
    end
  end

  private
  def import_slice(slice)
    case_no_to_appeal = Appeal.where(case_no: slice.pluck(:case_no)).index_by(&:case_no)
    slice.each do |record|
      appeal = case_no_to_appeal[record[:case_no]] || Appeal.new
      appeal.attributes = parse_record(record)
      appeal.save
    end
  end

  def parse_record(record)
    {
      case_type: parse_string(record[:case_type]),
      case_subtype: parse_string(record[:case_subtype]),
      status: parse_string(record[:status]),
      case_no: parse_string(record[:case_no]),
      appeal_no: parse_string(record[:appeal_no]),
      requester: parse_string(record[:requester]),
      custodian: parse_string(record[:custodian]),
      req_rec_date: parse_date(record[:req_rec_date]),
      resp_prov_date: parse_date(record[:resp_prov_date]),
      fees: parse_string(record[:fees]),
      petitions: parse_boolean(record[:petitions]),
      comply: parse_string(record[:comply]),
      date_opened: parse_date(record[:date_opened]),
      date_closed: parse_date(record[:date_closed]),
      reconsider_open_date: parse_date(record[:reconsider_open_date]),
      reconsider_close_date: parse_date(record[:reconsider_close_date]),
      in_cam_open_date: parse_date(record[:in_cam_open_date]),
      in_cam_close_date: parse_date(record[:in_cam_close_date]),
      request_to_court: parse_boolean(record[:request_to_court]),
      decisions_text: parse_decisions_text(record[:files]),
      decision_urls: parse_decisions_urls(record[:files]),
    }
  end

  def parse_decisions_text(files)
    files.pluck(:text).join(" ").gsub(/\s+/, " ").strip
  end

  def parse_decisions_urls(files)
    files.pluck(:path).map { |p| "https://wokewindows-data.s3.amazonaws.com/appeals/#{p}" }
  end
end
