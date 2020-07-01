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

  def format_yes_no(b)
    return format_unknown if b == nil
    b ? "Yes" : "No"
  end

  def format_currency(amount)
    return format_unknown if amount == nil
    number_to_currency(amount)
  end

  def format_forfeitures(fs)
    return format_unknown if fs.empty?
    links = fs.map { |f| link_to f.sucv, forfeiture_path(f) }
    safe_join links, ", "
  end
end
