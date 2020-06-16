# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Load incidents
Importer::CrimeIncidentReports.import_all
Importer::DistrictJournal.import_all

# Load annual earnings report (from HR department)
Importer::EmployeeEarnings.import_all

# Load BPD employee lists (these include empl_id field)
Importer::EmployeeListing.import_all

# Discover more BPD employees from incident_officers table, which was
# created by Importer::DistrictJournal above
Populater::OfficersFromIncidentOfficers.populate

# use fuzzy matching to populate hr_name for officers where we
# just have a journal_name (necessary so we can associate compensation
# with each officer later)
Populater::OfficerHrNames.populate

# set officer field on each IncidentOfficer object
Populater::IncidentOfficers.populate

# set officer field on each Compensation object
Populater::Compensations.populate

# bring in field contacts (the importer also sets the associations)
Importer::FieldContact.import_all
Importer::FieldContactName.import_all

# bring in internal affairs complaints
Importer::BpdIaData.import_all
