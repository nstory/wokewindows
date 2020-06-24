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
      # this is some ugly quadratic bull****
      matching = exact_match(co, officers)

      if matching.count != 1
        matching = officers.select do |off|
          match(co, off)
        end
      end

      if matching.count == 1
        co.officer = matching.first
        co.save
      end
    end
  end

  def self.exact_match(co, officers)
    officers.select { |o| o.hr_name && co.name && o.hr_name.downcase == co.name.downcase }
  end

  def self.match(co, off)
    return false if !off.hr_name
    return false if !co.name

    if HARD_CODED_MAPPING.has_key?(co.name)
      return HARD_CODED_MAPPING[co.name] == off.hr_name
    end

    # Officer.hr_name is in the format "Kirk,James T"
    # 2014 IA data has names like "Ptl James T T Kirk"
    # so, turn hr_name into /.*James.*T.*Kirk.*/ and see if it matches
    return true if regexp(reverse_name(off.hr_name)) =~ co.name

    # 2001-2011 IA data has names like "Kirk,James T" (very similar to hr_name),
    # so try matching against /.*Kirk.*James.*T.*/
    return true if regexp(off.hr_name) =~ co.name

    # also try in reverse (matching ComplaintOfficer.name regexp against hr_name)
    return true if regexp(co.name) =~ off.hr_name

    return false
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
