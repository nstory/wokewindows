Event = Struct.new(:record, :id, :time, :reported, :url, :location, :latitude, :longitude, keyword_init: true) do
  MARGIN = 300

  def relationship(start_time, end_time)
    if record.instance_of?(Incident)
      r1 = relationship_for_time(time, start_time, end_time)
      r2 = relationship_for_time(reported, start_time, end_time)
      return r1 if r1 == r2
      nil
    else
      relationship_for_time(time, start_time, end_time)
    end
  end

  def self.from_citation(citation)
    Event.new(
      record: citation,
      id: citation.ticket_number,
      time: parse_date_time(citation.event_date),
      location: citation.location_name,
      url: helpers.citation_url(citation, host: host)
    )
  end

  def self.from_field_contact(fc)
    Event.new(
      record: fc,
      id: fc.fc_num,
      time: parse_date_time(fc.contact_date),
      location: fc.street,
      url: helpers.field_contact_url(fc, host: host)
    )
  end

  def self.from_incident(inc)
    Event.new(
      record: inc,
      id: inc.incident_number,
      time: parse_date_time(inc.occurred_on_date),
      reported: parse_date_time(inc.report_date),
      location: inc.location_of_occurrence.first || inc.street,
      latitude: inc.latitude,
      longitude: inc.longitude,
      url: helpers.incident_url(inc, host: host)
    )
  end

  def self.from_officer(officer)
    [
      officer.citations.map { |c| from_citation(c) },
      officer.field_contacts.map { |fc| from_field_contact(fc) },
      officer.incidents.map { |inc| from_incident(inc) }
    ].flatten.select(&:time)
  end

  private
  def relationship_for_time(time, start_time, end_time)
    return nil if !time
    return :adjacent if time == start_time || time == end_time
    return :within if time >= start_time && time <= (end_time - 15*60)
    return :within_15_of_end if time >= start_time && time <= (end_time - 15*60)
    return :just_before if (start_time - time).abs <= MARGIN
    return :just_after if (time - end_time).abs <= MARGIN
    nil
  end
end

def helpers
  Rails.application.routes.url_helpers
end

def host
  "https://www.wokewindows.org"
end

def parse_ot_date_time(date, time)
  Time.strptime("#{date} #{time}", "%Y-%m-%d %H%M")
end

def parse_date_time(date_time)
  return nil if !date_time
  Time.strptime(date_time, "%Y-%m-%d %H:%M:%S")
end

def distance(lat1, lon1, lat2, lon2)
  return nil unless [lat1, lon1, lat2, lon2].all?
  Haversine.distance(lat1, lon1, lat2, lon2).to_miles
end

def overtime
  puts [
    "employee_id", "name", "date", "ot_start_time", "ot_end_time",
    "ot_description", "ot_worked_hours", "ot_hours", "relationship",
    "event_type", "id", "time", "reported", "location", "url"
  ].to_csv

  Officer.includes(:citations, :overtimes).find_each do |officer|
    overtimes = officer.overtimes.to_a
    events = Event.from_officer(officer)
    overtimes.each do |ot|
      ot_start = parse_ot_date_time(ot.date, ot.start_time)
      ot_end = parse_ot_date_time(ot.date, ot.end_time)
      events.each do |event|
        relationship = event.relationship(ot_start, ot_end)
        if relationship == :within
          puts [
            officer.employee_id,
            officer.name,
            ot.date,
            ot.start_time,
            ot.end_time,
            ot.description,
            ot.worked_hours,
            ot.ot_hours,
            relationship,
            event.record.class,
            event.id,
            event.time.strftime("%F %R"),
            event.reported && event.reported.strftime("%F %R"),
            event.location,
            event.url
          ].to_csv
        end
      end
    end
  end
end

def detail
  puts [
    "employee_id", "name", "detail_url",
    "detail_tracking_no", "detail_type", "detail_address",
    "detail_start", "detail_end",
    "relationship", "event_type", "id", "time", "location",
    "distance_miles", "url"
  ].to_csv

  Officer.includes(:citations, :field_contacts, :incidents, :details).find_each do |officer|
    details = officer.details.to_a
    events = Event.from_officer(officer)
    details.each do |detail|
      detail_start = parse_date_time(detail.start_date_time)
      detail_end = parse_date_time(detail.end_date_time)
      events.each do |event|
        relationship = event.relationship(detail_start, detail_end)
        if relationship
          puts [
            officer.employee_id,
            officer.name,
            helpers.detail_url(detail, host: host),
            detail.tracking_no,
            detail.detail_type_friendly,
            detail.address,
            detail.start_date_time,
            detail.end_date_time,
            relationship,
            event.record.class,
            event.id,
            event.time.strftime("%c"),
            event.location,
            distance(event.latitude, event.longitude, detail.latitude, detail.longitude),
            event.url
          ].to_csv
        end
      end
    end
  end
end

send ARGV[0].to_sym
