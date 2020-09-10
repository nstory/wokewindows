Shift = Struct.new(:source, :employee_id, :start_time, :end_time, keyword_init: true) do
  # adjacent; nearby (within 15m); overlap
  def relationship(oth)
    return :adjacent if adjacent?(oth)
    return :overlaps if overlaps?(oth)
    return :nearby if nearby(oth)
    return nil
  end

  def adjacent?(oth)
    return true if end_time == oth.start_time
    return true if start_time == oth.end_time
    return false
  end

  def nearby(oth)
    [oth.start_time - end_time, start_time - oth.end_time].each do |d|
      if d > 0 && d <= 60*15
        return d/60
      end
    end
    nil
  end

  def overlaps?(oth)
    # is my start_time within oth?
    return true if start_time >= oth.start_time && start_time < oth.end_time

    # is my end_time within oth?
    return true if end_time > oth.start_time && end_time <= oth.end_time

    # is oth entirely inside me?
    return true if oth.start_time >= start_time && oth.start_time <= end_time

    false
  end

  def as_csv
    [source, start_time.strftime("%c"), end_time.strftime("%c")]
  end
end

def parse_date_time(date, time)
  t = Chronic.parse(date)
  Time.new(t.year, t.month, t.day, time[0..1].to_i, time[2..3].to_i)
end

def overtime_shifts
  records = Parser::Csv.new("data/court_overtime_2014_2019.csv").records
  records.reject { |r| r[:id].blank? }
    .map do |r|
    Shift.new(
      source: :overtime,
      employee_id: r[:id].to_i,
      start_time: parse_date_time(r[:otdate], r[:starttime]), # DateTime.strptime("#{r[:otdate]} #{r[:starttime]}", "%d-%b-%y %H%M"),
      end_time: parse_date_time(r[:otdate], r[:endtime]),
    )
  end
end

def parse_detail_time(dt)
  Time.strptime(dt, "%F %H:%M")
end

def detail_shifts
  Detail.all.map do |d|
    Shift.new(
      source: :detail,
      employee_id: d.employee_number,
      start_time: parse_detail_time(d.start_date_time),
      end_time: parse_detail_time(d.end_date_time),
    )
  end
end

def all_shifts
  detail_shifts + overtime_shifts
end

puts ["employee_id", "relationship", "minutes_nearby", "s1", "s1_start", "s1_end", "s2", "s2_start", "s2_end"].to_csv

all_shifts.sort_by(&:start_time)
  .group_by(&:employee_id)
  .each do |employee_id, shifts|
  shifts.each_with_index do |s1, i|
    shifts[i+1...shifts.length].each do |s2|
      rel = s1.relationship(s2)
      if (rel)
        puts [employee_id, rel, s1.nearby(s2), *s1.as_csv, *s2.as_csv].to_csv
      end
    end
  end
end
