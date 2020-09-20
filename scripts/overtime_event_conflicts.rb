Event = Struct.new(:record, :id, :time, :url, keyword_init: true) do
  MARGIN = 300

  def relationship(start_time, end_time)
    return :adjacent if time == start_time || time == end_time
    return :within if time >= start_time && time <= end_time
    return :just_before if (start_time - time).abs <= MARGIN
    return :just_after if (time - end_time).abs <= MARGIN
    nil
  end

  def self.from_citation(citation)
    Event.new(
      record: citation,
      id: citation.ticket_number,
      time: parse_date_time(citation.event_date),
      url: helpers.citation_url(citation, host: host)
    )
  end

  def self.from_field_contact(fc)
    Event.new(
      record: fc,
      id: fc.fc_num,
      time: parse_date_time(fc.contact_date),
      url: helpers.field_contact_url(fc, host: host)
    )
  end

  def self.from_incident(inc)
    Event.new(
      record: inc,
      id: inc.incident_number,
      time: parse_date_time(inc.occurred_on_date),
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
  def self.helpers
    Rails.application.routes.url_helpers
  end

  def self.host
    "https://www.wokewindows.org"
  end

  def self.parse_date_time(date_time)
    return nil if !date_time
    Time.strptime(date_time, "%Y-%m-%d %H:%M:%S")
  end
end

def parse_ot_date_time(date, time)
  Time.strptime("#{date} #{time}", "%Y-%m-%d %H%M")
end

puts [
  "employee_id", "name", "date", "ot_start_time", "ot_end_time",
  "ot_description", "ot_worked_hours", "ot_hours", "relationship",
  "event_type", "id", "time", "url"
].to_csv

Officer.includes(:citations, :overtimes).find_each do |officer|
  overtimes = officer.overtimes.to_a
  events = Event.from_officer(officer)
  overtimes.each do |ot|
    ot_start = parse_ot_date_time(ot.date, ot.start_time)
    ot_end = parse_ot_date_time(ot.date, ot.end_time)
    events.each do |event|
      relationship = event.relationship(ot_start, ot_end)
      if relationship
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
          event.time.strftime("%c"),
          event.url
        ].to_csv
      end
    end
  end
end
