# sets the officer_id field on each ComplaintOfficer
class Populater::ComplaintOfficers
  HARD_CODED_MAPPING = {
    "Ezekial,Jason" => "Ezekiel,Jason M",
    "Martin-Gows,Sandra A" => "Martin-Gore,Sandra A",
    "Rackaukas,Richard" => "Rackauskas,Richard F",
    "Ptl Christopher P Adams" => "Adams,Christopher",
    "Ptl Jean-Louis G. Jean" => "Jean Louis,Jean G.",
    "Ptl Jimmy Le NGUYEN" => "Nguyen,Jimmy Le",
    "Ptl Quion Tee Riley Jr." => "Riley Jr.,Quion Tee",
    "Sergt William J J Walsh" => "Walsh,William James"
  }

  def self.populate
    officers = Officer.find_each.to_a

    # if I don't includes(:complaint) it loads them each one-at-a-time
    # but I dunno why
    ComplaintOfficer.includes(:complaint).find_in_batches do |group|
      ComplaintOfficer.transaction do
        populate_group(group, officers)
      end
    end
  end

  private
  def self.populate_group(group, officers)
    group.each do |co|
      # this is some ugly quadratic-ish bull
      matching = officers.select do |off|
        match(co, off)
      end

      if matching.count == 1
        co.officer = matching.first
        co.save
      end
    end
  end

  def self.match(co, off)
    return false if !off.hr_name
    return false if !co.name

    if HARD_CODED_MAPPING.has_key?(co.name)
      return HARD_CODED_MAPPING[co.name] == off.hr_name
    end

    # 2001-2011 data have badge numbers
    if co.badge
      return false if !off.badge
      return false if off.badge.to_i != co.badge.to_i
      regexp(co.name) =~ off.hr_name || regexp(off.hr_name) =~ co.name
    else # 2014 data just have names
      regexp(reverse_name(off.hr_name)) =~ co.name
    end
  end

  def self.regexp(name)
    norm = name.downcase.gsub(/[^a-z]/, ".*")
    Regexp.new("#{norm}", Regexp::IGNORECASE)
  end

  # "Kirk,James T." -> "James T. Kirk"
  def self.reverse_name(name)
    matches = name.match(/^(.*),(.*)$/)
    matches ? "#{matches[2]} #{matches[1]}" : name
  end
end
