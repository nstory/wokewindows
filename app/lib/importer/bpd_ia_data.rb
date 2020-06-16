# imports the 2001-2011 data parsed by Parser::BpdIaData
class Importer::BpdIaData
  SLICE = 500

  def self.import_all
    parser = Parser::BpdIaData.new("data/bpd_ia_data_2001_2011.txt")
    import(parser.records)
  end

  def self.import(records)
    records.each_slice(SLICE) do |slice|
      Complaint.transaction do
        import_slice(slice)
      end
    end
  end

  def self.import_slice(slice)
    by_ia_number = Hash.new { |h,k| h[k] = Complaint.new }
    by_ia_number.merge!(Complaint.by_ia_number(slice.pluck(:ia_no)))

    slice.each do |record|
      complaint = by_ia_number[record[:ia_no]]
      complaint.attributes = {
        ia_number: record[:ia_no],
        case_number: parse_int(record[:case_no]),
        incident_type: record[:incident_type],
        received_date: parse_date(record[:received_date])
      }
      add_complaint_officer(complaint, record)
      complaint.save
    end
  end

  private
  def self.add_complaint_officer(complaint, record)
    attr = {
      "name" => "#{record[:last_name]},#{record[:first_name]}",
      "title" => parse_string(record[:title]),
      "badge" => parse_string(record[:badge_id_number]),
      "allegation" =>  parse_string(record[:allegation]),
      "finding" => parse_string(record[:finding]),
      "finding_date" => parse_date(record[:finding_date])
    }

    exists = complaint.complaint_officers.any? do |co|
      co_attr = co.attributes.slice(*attr.keys)
      co_attr == attr
    end

    if !exists
      complaint.complaint_officers << ComplaintOfficer.create(attr)
    end
  end

  def self.parse_string(str)
    str.blank? ? nil : str
  end

  def self.parse_int(str)
    str.blank? ? nil : str.to_i
  end

  def self.parse_date(date)
    time = Chronic.parse(date)
    time ? time.strftime("%F") : nil
  end
end
