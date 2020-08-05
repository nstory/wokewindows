#!/bin/bash
# daily cron job

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

rails r "FieldContact.connection.execute('delete from citations_field_contacts')"
rails r "FieldContact.connection.execute('delete from field_contacts_incidents')"
rails r 'FieldContactName.delete_all'
rails r 'FieldContact.delete_all'
rails r 'Importer::FioContacts.import_all'
rails r 'Importer::FioPeople.import_all'
rails r 'Populater::FieldContactsCitations.populate'
rails r 'Populater::FieldContactsIncidents.populate'
rails counters:fix
