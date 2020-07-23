# associates each compensation with its officer
class Populater::Compensations
  HARD_CODED_MAPPING = [
    {name: /^flaherty,sean$/i, title: /Lieutenant/i, employee_id: 11105},
    {name: /^flaherty,sean$/i, title: /Police Offc/i, employee_id: 11830},
    {name: /^butler,michael v$/i, title: /Auto Inv/i, employee_id: 8205},
    {name: /^butler,michael v$/i, title: /^Police Officer$/i, employee_id: 120925},
    {name: /^Harrington,Richard F$/i, title: /^Police Officer$/i, employee_id: 8856},
    {name: /^Harrington,Richard F$/i, title: /equipop/i, employee_id: 93467},
    {name: /^Hamilton,Christopher$/i, title: /Lieutenant/i, employee_id: 12121},
    {name: /^Hamilton,Christopher$/i, title: /Police Officer/i, employee_id: 113896},
    {name: /^Murphy,Sean M$/i, title: /Police Dispatcher/i, employee_id: 96614},
    {name: /^Murphy,Sean M$/i, title: /Police Officer/i, employee_id: 144472},
  ]

  def self.populate
    @hr_name_to_officers = Officer.find_each.group_by(&:hr_name)
    @reject_list = reject_list

    Compensation.find_in_batches do |group|
      Compensation.transaction do
        populate_group(group)
      end
    end
  end

  private
  def self.populate_group(group)
    group.each do |compensation|
      officer = find_officer(compensation)
      if officer
        compensation.officer = officer
        compensation.save
      end
    end
  end

  def self.find_officer(compensation)
    # first check hard-codes
    hc = HARD_CODED_MAPPING.find { |m| m[:name] =~ compensation.name && m[:title] =~ compensation.title }
    return Officer.find_by(employee_id: hc[:employee_id]) if hc

    # bail if there is ambiguity
    return nil if @reject_list.include?(compensation.name)

    # return unambiguous match
    officers = @hr_name_to_officers[compensation.name]
    return officers.first if officers && officers.count == 1

    # :shrug:
    nil
  end

  # if a name appears twice in any year, don't use it ever
  def self.reject_list
    Compensation.connection.select_all(
      'select year, name, count(*) as count from compensations group by year, name having count(*) > 1'
    ).pluck("name").uniq
  end
end
