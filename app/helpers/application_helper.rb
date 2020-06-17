module ApplicationHelper
  def format_date(str)
    if !str.blank?
      begin
        date = Date.strptime(str, "%F")
        return date.strftime("%b %-d, %Y")
      rescue ArgumentError
      end
    end
    raw('<span class="unknown">N/A</span>')
  end

  def format_zip(n)
    if !n
      raw('<span class="unknown">N/A</span>')
    else
      n.to_s.rjust(5, "0")
    end
  end
end
