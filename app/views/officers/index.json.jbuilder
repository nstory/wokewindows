# vi: ft=ruby

json.officers @officers do |officer|
  json.employee_id officer.employee_id
  json.name officer.name
  json.title officer.title
  json.doa officer.doa
  json.total_earnings officer.total_earnings
  json.complaints_count officer.complaints_count
  json.field_contacts_count officer.field_contacts_count
  json.incidents_count officer.incidents_count
end
