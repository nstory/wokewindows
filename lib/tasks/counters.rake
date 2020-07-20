namespace :counters do
  task fix: :environment do
    FieldContact.counter_culture_fix_counts
    FieldContactName.counter_culture_fix_counts
    Incident.counter_culture_fix_counts
    SwatsOfficer.counter_culture_fix_counts
    Detail.counter_culture_fix_counts
    Citation.counter_culture_fix_counts
    ArticlesOfficer.counter_culture_fix_counts
    Officer.fix_ia_score
  end
end
