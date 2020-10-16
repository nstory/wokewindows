#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

mkdir -p data
aws s3 cp 's3://wokewindows-data/CY2015_Annual_Earnings_BPD.csv.gz' data/
aws s3 cp 's3://wokewindows-data/ALPHa_LISTING_BPD_with_badges_1.csv.gz' data/
aws s3 cp 's3://wokewindows-data/alpha_listing_20200715.csv.gz' data/
aws s3 cp 's3://wokewindows-data/roster_20200904.csv.gz' data/

rails r Importer::EmployeeListing.import_all
