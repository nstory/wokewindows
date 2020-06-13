# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Officer.import_from_bpd_annual_earnings(LoadCsv.new("data/CY2015_Annual_Earnings_BPD.csv").records)
Officer.import_from_alpha_listing(LoadCsv.new("data/ALPHa_LISTING_BPD_with_badges_1.csv").records)
journals = Dir.glob("data/journals/*.pdf").map { |p| LoadDistrictJournal.new(p) }
Officer.import_from_journal_records(journals.flat_map(&:get_records))
Compensation.import_earnings(LoadEmployeeEarningsReport.all_with_year)
Officer.populate_hr_names_using_compensations
Officer.populate_hard_coded_hr_names

incidents = LoadCrimeIncidentReports.new("data/tmpqy9o_jgd.csv").get_records
Incident.import_incident_reports(incidents)
Incident.import_journals(journals)
