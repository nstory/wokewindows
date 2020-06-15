# creates the association between each IncidentOfficer and its Officer
class Populater::IncidentOfficers
  def self.populate
    id_to_officer = Officer.by_employee_id
    IncidentOfficer.find_in_batches do |group|
      IncidentOfficer.transaction do
        group.each do |io|
          officer = id_to_officer[io.employee_id]
          if officer && officer.journal_name == io.employee_name
            io.officer = officer
            io.save
          end
        end
      end
    end
  end
end
