namespace :counters do
  task fix: :environment do
    FieldContact.counter_culture_fix_counts
    FieldContactName.counter_culture_fix_counts
    Incident.counter_culture_fix_counts
    SwatsOfficer.counter_culture_fix_counts
  end
end
