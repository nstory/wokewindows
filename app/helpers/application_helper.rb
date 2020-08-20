module ApplicationHelper
  def format_unknown
    raw('<span class="unknown">N/A</span>')
  end

  def format_array(arr)
    return format_unknown if arr.blank?
    safe_join(arr, ", ")
  end

  def format_date(str)
    if !str.blank?
      begin
        date = Date.strptime(str, "%F")
        return date.strftime("%b %-d, %Y")
      rescue ArgumentError
      end
    end
    format_unknown
  end

  def format_date_time(str)
    if !str.blank?
      begin
        date = DateTime.strptime(str, "%F %T")
        return date.strftime("%b %-d, %Y %-I:%M:%S %p")
      rescue ArgumentError
      end
    end
    format_unknown
  end

  def format_zip(n)
    if !n
      format_unknown
    else
      n.to_s.rjust(5, "0")
    end
  end

  def format_text(str)
    if str == nil
      return format_unknown
    end
    str
  end

  def format_titleize(str)
    return format_unknown if str.blank?
    str.titleize
  end

  def format_upcase(str)
    return format_unknown if str.blank?
    str.upcase
  end

  def format_yes_no(b)
    return format_unknown if b == nil
    b ? "Yes" : "No"
  end

  def format_currency(amount)
    return format_unknown if amount == nil
    number_to_currency(amount)
  end

  def format_currency_dollars(amount)
    return format_unknown if amount == nil
    format_currency(amount)[0...-3]
  end

  def contact_us(text = nil)
    email = "n"+"s"+"t"+"ory@wokewindows.org"
    text ||= email
    mail_to email, text, encode: "javascript"
  end

  def format_minutes(value)
    return format_unknown if value == nil
    hours = (value / 60).floor
    minutes = value % 60
    "#{hours}:#{'%02d' % minutes}"
  end

  def format_field_contacts(field_contacts)
    return format_unknown if field_contacts.empty?
    links = field_contacts.map { |fc| link_to fc.fc_num, field_contact_path(fc) }
    safe_join links, ", "
  end

  def format_officer(officer)
    return format_unknown if !officer
    link_to officer.name, officer_path(officer)
  end
end
