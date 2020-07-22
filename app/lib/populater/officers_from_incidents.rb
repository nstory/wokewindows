class Populater::OfficersFromIncidents

  def self.populate
    id_to_name = employee_id_to_employee_name
    id_to_officer = Hash.new { |h,k| h[k] = Officer.new }
    id_to_officer.merge!(Officer.by_employee_id)

    Officer.transaction do
      id_to_name.each do |employee_id, employee_name|
        officer = id_to_officer[employee_id]
        if nil == officer.journal_name
          officer.employee_id = employee_id
          officer.journal_name = employee_name
          officer.save
        end
      end
    end
  end

  private

  # generated from incidents table. the table contains mistakes
  # where the wrong id is used for an officer (I guess it's manually
  # entered by someone?). we assume the name that's used most often
  # with an id is correct
  def self.employee_id_to_employee_name
    # create a hash with count of names with each id:
    # hash[employee_id][employee_name] = count
    hash = Hash.new { |h,k| h[k] = Hash.new(0) }
    Incident.find_each
      .select(&:officer_journal_name_id)
      .each do |o|
      # employee ids below 14,000 we should have from the spreadsheet,
      # if we're seeing a new one in a journal, probably an error
      if o.officer_journal_name_id >= 14000
        hash[o.officer_journal_name_id][o.officer_journal_name_name] += 1
      end
    end

    # create a new hash with the most popular name for each id:
    # hash[employee_id] = employee_name
    hash.map do |employee_id,names|
      [employee_id, names.max_by { |name,count| count }.first]
    end.to_h
  end
end
