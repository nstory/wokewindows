# sets the officer_id field on each ComplaintOfficer
class Populater::ComplaintOfficers
  def self.populate
    officers = Officer.find_each.select(&:badge)

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
    return true if hard_coded_match(co.name, off.hr_name)

    return false if !off.badge
    return false if !co.badge
    return false if off.badge.to_i != co.badge.to_i

    regexp(co.name) =~ off.hr_name || regexp(off.hr_name) =~ co.name
  end

  def self.hard_coded_match(co_name, hr_name)
    mapping = {
      "Ezekial,Jason" => "Ezekiel,Jason M",
      "Martin-Gows,Sandra A" => "Martin-Gore,Sandra A",
      "Rackaukas,Richard" => "Rackauskas,Richard F"
    }
    return mapping[co_name] == hr_name
  end

  def self.regexp(name)
    norm = name.downcase.gsub(/[^a-z]/, ".*")
    Regexp.new("#{norm}", Regexp::IGNORECASE)
  end
end
