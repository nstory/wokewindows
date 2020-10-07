#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

mkdir -p data
aws s3 cp 's3://wokewindows-data/iad_cases_2010-01-01_to_2020-08-15.csv.gz' data/
aws s3 cp 's3://wokewindows-data/2010_to_2020_allegations.csv.gz' data/
aws s3 cp 's3://wokewindows-data/bpd_ia_data_2001_2011.txt' data/
aws s3 cp 's3://wokewindows-data/2014_Officer__IA_Log_redacted.csv.gz' data/

rails r 'ComplaintOfficer.delete_all'
rails r 'Complaint.delete_all'
rails r 'Importer::BpdIaData.import_all'
rails r 'Importer::OfficerIaLog.import_all'
rails r 'Populater::ComplaintOfficers.populate'
rails r 'Populater::Officers.populate'
rails r 'Officer.fix_ia_score'
