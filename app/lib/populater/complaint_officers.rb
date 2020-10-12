# sets the officer_id field on each ComplaintOfficer
class Populater::ComplaintOfficers
  MAPPINGS = [
    [{"name" => "Ezekial,Jason"}, 11817],
    [{"name" => "Martin-Gows,Sandra A"}, 9749],
    [{"name" => "Rackaukas,Richard"}, 11636],
    [{"name" => "Ptl Christopher P Adams"}, 50576],
    [{"name" => "Ptl Jean-Louis G. Jean"}, 102661],
    [{"name" => "Ptl Jimmy Le NGUYEN", "badge" => "3115"}, 116889],
    [{"name" => "Ptl Quion Tee Riley Jr."}, 105620],
    [{"name" => "Ciccolo,Stephen"}, 9266],
    [{"name" => "Columbo,Domenic A"}, 120929],
    [{"name" => "Flaherty,Sean", "badge" => "186"}, 11105],
    [{"name" => "Flaherty,Sean", "title" => "Lieut"}, 11105],
    [{"name" => "Flaherty,Sean", "badge" => "1109"}, 11830],
    [{"name" => "Flaherty,Sean", "title" => "Ptl"}, 11830],
    [{"name" => "Murray,Timothy", "title" => "Captain"}, 8907],
    [{"name" => "Harrington,Richard F", "title" => "Ptl"}, 8856],
    [{"name" => "Harrington,Richard F", "title" => "Police Officer"}, 8856],
    [{"name" => "Flynn,Robert", "badge" =>"4343"}, 81082],
    [{"name" => "Doherty,Brian J", "badge" => "4168"}, 135945],
    [{"name" => "Doherty,Brian J", "badge" => "5550"}, 10258],
    [{"name" => "Manning,Michael"}, -1], # retired, not in database
    [{"name" => "Walsh,Michael D", "badge" => "1710"}, -1], # retired, not in database
  ]

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
      hard_coded_id = match_hard_coded(co)
      if hard_coded_id
        co.officer = Officer.find_by(employee_id: hard_coded_id)
        co.save
        next
      end

      # this is some ugly quadratic bull****
      matching = exact_match(co, officers)

      if matching.count != 1
        matching = officers.select do |off|
          match(co, off)
        end
      end

      if matching.count == 1
        unless ruled_out(co, matching.first)
          co.officer = matching.first
          co.save
        end
      end
    end
  end

  def self.match_hard_coded(co)
    MAPPINGS.each do |criteria, employee_id|
      if co.attributes.slice(*criteria.keys) == criteria
        return employee_id
      end
    end
    nil
  end

  def self.exact_match(co, officers)
    officers.select { |o| o.hr_name && co.name && o.hr_name.downcase == co.name.downcase }
  end

  def self.match(co, off)
    return false if !off.hr_name
    return false if !co.name

    # if HARD_CODED_MAPPING.has_key?(co.name)
    #   return HARD_CODED_MAPPING[co.name] == off.hr_name
    # end

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

  def self.ruled_out(complaint_officer, officer)
    complaint = complaint_officer.complaint
    if complaint.received_date && officer.doa
      return true if complaint.received_date < officer.doa
    end
    false
  end
end
