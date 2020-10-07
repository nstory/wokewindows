# imports the 2001-2011 data parsed by Parser::BpdIaData
# also imports the 2010_to_2020 data parsed by Parser::Allegations
class Importer::BpdIaData < Importer::Importer
  SLICE = 500

  def self.import_all
    parsers = [
      Parser::IadCases20200815.new("data/iad_cases_2010-01-01_to_2020-08-15.csv.gz"),
      Parser::Allegations.new("data/2010_to_2020_allegations.csv.gz"),
      Parser::BpdIaData.new("data/bpd_ia_data_2001_2011.txt")
    ]
    parsers.each do |parser|
      new(parser).import
    end
  end

  def import
    present_ia_numbers = Complaint.pluck(:ia_number).map { |n| [n, true] }.to_h
    records.each_slice(SLICE) do |slice|
      Complaint.transaction do
        import_slice(slice, present_ia_numbers)
      end
    end
  end

  def import_slice(slice, present_ia_numbers)
    by_ia_number = complaints_by_number(slice.pluck(:ia_no))

    slice.each do |record|
      next if should_reject_record?(record)

      # if a record existed from a previous import, skip it. we do the
      # most recent/accurate imports first. if it's previously been
      # created in this import, however, we may need to update it e.g.
      # with additional complaint_officers
      next if present_ia_numbers[record[:ia_no]]
      complaint = by_ia_number[record[:ia_no]]
      complaint.attributes = {
        ia_number: record[:ia_no],
        case_number: parse_int(record[:case_no]),
        incident_type: record[:incident_type],
        received_date: parse_date(record[:received_date])
      }
      add_complaint_officer(complaint, record)
      complaint.add_attribution(attribution)
      complaint.save
    end
  end

  private
  def add_complaint_officer(complaint, record)
    attr = {
      "name" => parse_name(record[:first_name], record[:last_name]),
      "title" => parse_string(record[:title]),
      "badge" => parse_string(record[:badge_id_number]),
      "allegation" =>  parse_string(record[:allegation]),
      "finding" => parse_finding(record[:finding]),
      "finding_date" => parse_date(record[:finding_date])
    }

    complaint_officer = complaint.complaint_officers.find do |co|
      co_attr = co.attributes.slice(*attr.keys)
      co_attr == attr
    end

    if !complaint_officer
      complaint_officer = ComplaintOfficer.create(attr)
      complaint.complaint_officers << complaint_officer
    end

    # in iad_cases_20200815 there can be multiple allegations against an
    # officer differing only in the action_taken field; we represent these
    # as one complaint_officer with multiple action_taken
    complaint_officer.action_taken << parse_string(record[:action_taken])
    complaint_officer.action_taken = complaint_officer.action_taken.compact.uniq
  end

  def should_reject_record?(record)
    !["Citizen complaint", "Internal investigation"].include?(record[:incident_type])
  end

  def parse_finding(str)
    return nil if str.blank?
    return "Sustained" if /^Sustained .$/ =~ str
    str
  end

  def parse_name(first_name, last_name)
    return nil if first_name.blank? && last_name.blank?
    return "Unknown" if /unknown/i =~ last_name
    "#{last_name},#{first_name}"
  end
end
