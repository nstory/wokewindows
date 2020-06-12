class Officer < ApplicationRecord
  def self.import_from_journal_records(records)
    records.each do |record|
      if /^(\d+) +(.+)$/ =~ record[:officer]
        employee_id = $1.to_i
        journal_name = $2
        officer = Officer.find_or_create_by(employee_id: employee_id)
        if !officer.journal_name
          officer.journal_name = journal_name
          officer.save
        end
      end
    end
  end
end
