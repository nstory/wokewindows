module FieldContactsHelper
  def format_contact_officer(field_contact)
    format_field_contact_officer(
      field_contact.contact_officer_name,
      field_contact.contact_officer
    )
  end

  def format_supervisor(field_contact)
    format_field_contact_officer(
      field_contact.supervisor_name,
      field_contact.supervisor
    )
  end

  def format_field_contact_duration(text)
    mapping = {
      "five_to_ten_minutes" => "5m - 10m",
      "fifteen_to_twenty_minutes" => "15m - 20m",
      "ten_to_fifteen_minutes" => "10m - 15m",
      "less_than_five_minutes" => "< 5m",
      "longer_than_two_hours" => "> 2h",
      "thirty_to_forty_five_minutes" => "30m - 45m",
      "one_to_two_hours" => "1h - 2h",
      "twenty_five_to_thirty_minutes" => "25m - 30m",
      "twenty_to_twenty_five_minutes" => "20m - 25m",
      "forty_five_to_sixty_minutes" => "45m - 60m"
    }
    mapping.fetch(text, format_unknown)
  end

  # this links citations and incidents mentioned in the narrative
  def format_narrative(field_contact)
    return format_unknown if field_contact.narrative.blank?

    # mapping from text to link
    mapping = field_contact.incidents.inject({}) do |h,inc|
      h[inc.incident_number.to_s] = incident_path(inc)
      h["i#{inc.incident_number}"] = incident_path(inc)
      h
    end
    mapping = field_contact.citations.inject(mapping) do |h,cit|
      h[cit.ticket_number] = citation_path(cit)
      h
    end

    # this is suspicious, it's possible we could substitute the same text
    # twice and mess up a link we just created or something
    html = simple_format(field_contact.narrative)
    mapping.each do |text, url|
      html.gsub!(Regexp.new('\b' + text + '\b', Regexp::IGNORECASE), link_to(text, url))
    end

    raw(html)
  end

  private
  def format_field_contact_officer(name, officer)
    text = name.blank? ? "Unknown" : name.titleize
    if officer
      link_to(text, officer_path(officer))
    else
      text
    end
  end
end
