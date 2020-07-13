module FieldContactsHelper
  def format_contact_officer(field_contact)
    format_officer(
      field_contact.contact_officer_name,
      field_contact.contact_officer
    )
  end

  def format_supervisor(field_contact)
    format_officer(
      field_contact.supervisor_name,
      field_contact.supervisor
    )
  end

  def format_narrative(field_contact)
    return format_unknown if field_contact.narrative.blank?

    # mapping from text to link
    mapping = field_contact.incidents.inject({}) do |h,inc|
      h[inc.incident_number.to_s] = incident_path(inc)
      h["I#{inc.incident_number}"] = incident_path(inc)
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
      html.gsub!(Regexp.new('\b' + text + '\b'), link_to(text, url))
    end

    raw(html)
  end

  private
  def format_officer(name, officer)
    if officer
      link_to(name, officer_path(officer))
    else
      name
    end
  end
end
