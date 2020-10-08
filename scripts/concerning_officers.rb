def most_recent_activity(officer)
  dates = officer.incidents.pluck(:report_date).map { |rd| rd.sub(/ .*/, "") }
  dates.max
end

def concerning_articles(officer)
  officer.articles_officers.confirmed.where(concerning: true).count > 0
end

def uniq_action_taken(officer)
  officer.complaint_officers.pluck(:action_taken).flatten.uniq.sort
end

FIELDS = {
  url: ->(r) { "https://www.wokewindows.org/officers/#{r.employee_id}" },
  name: ->(r) { r.name },
  title: ->(r) { r.title },
  organization: ->(r) { r.organization },
  lead_entry: ->(r) { r.lead_entry },
  law_breaking: ->(r) { r.ia_sustained_law_breaking.empty? ? "N" : "Y" },
  use_of_force: ->(r) { r.ia_sustained_use_of_force.empty? ? "N" : "Y" },
  untruthfulness: ->(r) { r.ia_sustained_untruthfulness.empty? ? "N" : "Y" },
  concerning_news: ->(r) { concerning_articles(r) ? "Y" : "N" },
  most_recent_incident: ->(r) { most_recent_activity(r) },
  action_taken: ->(r) { uniq_action_taken(r).join(", ") }
}

records = Officer.where(active: true)
  .select do |r|
    r.lead_entry ||
    r.ia_sustained_law_breaking.count > 0 ||
    r.ia_sustained_use_of_force.count > 0 ||
    r.ia_sustained_untruthfulness.count > 0 ||
    uniq_action_taken(r).any? { |a| /termination/i =~ a }
    # concerning_articles(r) ||
end.reject { |o| /ADMINISTRATIVE LEAVE SECTION|SUSPENDED SECTION|MEDICALLY INCAPACITATED SCTN|LEAVE OF ABSENCE SECTION/i =~ o.organization }
.reject { |o| /Civili/i =~ o.rank }

puts FIELDS.keys.to_csv
records.each do |r|
  puts FIELDS.values.map { |l| l.call(r) }.to_csv
end
