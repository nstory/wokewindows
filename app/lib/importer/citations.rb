class Importer::Citations < Importer::Importer
  SLICE = 1000

  def self.import_all
    parser = Parser::Citations.new("data/boston_pd_citations_with_names_2011_2020.csv")
    Citation.delete_all
    new(parser).import
  end

  def import
    @officer_by_employee_id = Officer.by_employee_id
    records.each_slice(SLICE) do |slice|
      Citation.transaction do
        import_slice(slice)
      end
    end
  end

  private

  def import_slice(slice)
    by_ticket_number = citations_by_ticket_number(
      slice.map { |r| map_ticket_num(r) }
    )
    slice.each do |record|
      next unless map_ticket_num(record)
      citation = by_ticket_number[map_ticket_num(record)]
      citation.attributes = map_record(record)
      citation.add_offense(CitationOffense.new(map_record_offense(record)))
      citation.officer ||= @officer_by_employee_id[citation.officer_number]
      citation.add_attribution(attribution)
      citation.save
    end
  end

  def citations_by_ticket_number(numbers)
    hash = Hash.new { |h,k| h[k] = Citation.new }
    hash.merge!(
      Citation.where(ticket_number: numbers).index_by(&:ticket_number)
    )
    hash
  end

  def map_record(record)
    attributes = {
      ticket_number: map_ticket_num(record),
      issuing_agency: parse_string(record[:issuing_agency]),
      officer_number: parse_int(record[:officer_id]),
      ticket_type: parse_string(record[:type]),
      source: parse_string(record[:source]),
      violator_type: parse_string(record[:violator_type]),
      cdl: parse_boolean(record[:cdl]),
      license_class: parse_string(record[:class]),
      event_date: parse_event_date(record),
      location_id: parse_int(record[:location_id]),
      location_name: parse_string(record[:location_name]),
      posted_speed: parse_int_zero_nil(record[:posted_speed]),
      violation_speed: parse_int_zero_nil(record[:violation_speed]),
      posted: parse_boolean(record[:posted]),
      radar: parse_string(record[:radar]),
      clocked: parse_string(record[:clocked]),
      race: parse_string(record[:race]),
      sex: parse_string(record[:sex]),
      vehicle_color: parse_string(record[:vehicle_color]),
      make: parse_string(record[:make]),
      model_year: parse_int(record[:model_yr]),
      sixteen_pass: parse_boolean(record[:"16_pass"]),
      haz_mat: parse_boolean(record[:haz_mat]),
      amount: parse_int(record[:amount]),
      paid: parse_boolean(record[:paid]),
      hearing_requested: parse_boolean(record[:hearing_requested]),
      court_code: parse_string(record[:court_code]),
      age: parse_int(record[:age]),
      searched: parse_boolean(record[:searched])
    }
    attributes.compact
  end

  def map_record_offense(record)
    {
      offense: parse_string(record[:offense]),
      description: parse_string(record[:offense_description]),
      # assessment: parse_money(record[:assessment]),
      # expected_assessment: parse_money(record[:expected_assessmnt]),
      # display_assessment: parse_money(record[:display_assessmnt]),
      disposition: parse_string(record[:disposition]),
      disposition_description: parse_string(record[:disposition_desc]),
      # major_incident: parse_boolean(record[:major_indc]),
      # surchargeable: parse_boolean(record[:surchargeable]),
      # sdip_points: parse_int(record[:sdip_points])
    }
  end

  def map_ticket_num(record)
    record[:ticket_num].blank? ? nil : record[:ticket_num].upcase
  end

  def key(record)
    record.slice(
      :event_date, :time_hh, :time_mm, :am_pm, :location_id, :offense,
      :make, :model_yr, :age
    ).values
  end

  def parse_boolean(str)
    return true if /^y/i =~ str
    return false if /^n/i =~ str
    nil
  end

  def parse_event_date(record)
    if /^\d{4}-\d{2}-\d{2}/.match(record[:event_date])
      t = "%s %02d:%02d %s" % [$&, record[:time_hh].to_i, record[:time_mm].to_i, record[:am_pm]]
      return parse_date_time(t)
    end
    return nil
  end

  def parse_int_zero_nil(str)
    return nil if str.blank?
    i = str.to_i
    i == 0 ? nil : i
  end
end
