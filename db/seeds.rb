# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Importer::EmployeeListing.import_all
journal_records = Dir.glob("data/journals/*.pdf").map { |p| LoadDistrictJournal.new(p) }.flat_map(&:get_records)
Officer.import_from_journal_records(journal_records)
Importer::EmployeeEarnings.import_all
Officer.populate_hr_names_using_compensations
Officer.populate_hard_coded_hr_names

Importer::CrimeIncidentReports.import_all
Incident.import_journals(journal_records)
Officer.populate_incident_officers
Importer::FieldContact.import_all
Importer::FieldContactName.import_all
