# populate contact_officer_id and supervisor_id fields
class Populater::FieldContactOfficers
  def self.populate
    by_emp_id = Officer.by_employee_id
    FieldContact.find_in_batches do |group|
      group.each do |fc|
        # populate contact_officer
        contact_officer = by_emp_id[fc.contact_officer_employee_id]
        fc.contact_officer = contact_officer if contact_officer

        # populate supervisor
        supervisor = by_emp_id[fc.supervisor_employee_id]
        fc.supervisor = supervisor if supervisor
      end

      FieldContact.transaction do
        group.each(&:save)
      end
    end
  end
end
