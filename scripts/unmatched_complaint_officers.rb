records = ComplaintOfficer.includes(:complaint)
  .reject { |co| co.title =~ /Civ|Framing/i || !co.title }
  .reject(&:officer_id)
  .reject { |co| /Unkn/i =~ co.name }
  .reject { |co| co.name.blank? }

records = records.sort_by { |co| records.select { |r| r.name == co.name }.map { |r| r.complaint.received_date }.max }
records = records.reverse

puts ComplaintOfficer.first.attributes.keys.to_csv
records.each do |record|
  puts record.attributes.values.to_csv
end
