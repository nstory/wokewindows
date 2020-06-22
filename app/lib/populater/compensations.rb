# associates each compensation with its officer
class Populater::Compensations
  def self.populate
    hr_name_to_officers = Officer.find_each.group_by(&:hr_name)
    reject_list = self.reject_list

    Compensation.find_in_batches do |group|
      Compensation.transaction do
        populate_group(group, hr_name_to_officers, reject_list)
      end
    end
  end

  private
  def self.populate_group(group, hr_name_to_officers, reject_list)
    group.each do |compensation|
      next if reject_list.include?(compensation.name)
      officers = hr_name_to_officers[compensation.name]
      if officers && officers.count == 1
        compensation.officer = officers.first
        compensation.save
      end
    end
  end

  # if a name appears twice in any year, don't use it ever
  def self.reject_list
    Compensation.connection.select_all(
      'select year, name, count(*) as count from compensations group by year, name having count(*) > 1'
    ).pluck("name").uniq
  end
end
