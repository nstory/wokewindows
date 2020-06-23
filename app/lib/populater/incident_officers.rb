# creates the association between each Incident and its Officer
class Populater::IncidentOfficers
  def self.populate
    id_to_officer = Officer.by_employee_id
    Incident.find_in_batches do |group|
      Incident.transaction do
        group.each do |inc|
          officer = id_to_officer[inc.officer_journal_name_id]
          if officer && officer.journal_name == inc.officer_journal_name_name
            inc.officer = officer
            inc.save
          end
        end
      end
    end
  end
end
