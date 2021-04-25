.EXPORT_ALL_VARIABLES:

APPEALS_JSONL_FILE=data/appeals.jsonl.gz
DETAILS_PAID_FILES=data/Details_Paid_2017.xlsx data/Details_Paid_2018.xlsx data/Detail_Records_January_to_December_2019.xlsx data/Details_Paid_2020.xlsx
CITATIONS_CSV=data/boston_pd_citations_with_names_2011_2020.csv

data/Details_Paid_2017.xlsx:
	wget 'https://cdn.muckrock.com/foia_files/2021/01/27/Details_Paid_2017.xlsx' -O data/Details_Paid_2017.xlsx

data/Details_Paid_2018.xlsx:
	wget 'https://cdn.muckrock.com/foia_files/2021/01/27/Details_Paid_2018.xlsx' -O data/Details_Paid_2018.xlsx

data/Detail_Records_January_to_December_2019.xlsx:
	wget 'https://cdn.muckrock.com/foia_files/2020/07/07/Detail_Records_January_to_December_2019.xlsx' -O data/Detail_Records_January_to_December_2019.xlsx

data/Details_Paid_2020.xlsx:
	wget 'https://cdn.muckrock.com/foia_files/2021/01/27/Details_Paid_2020.xlsx' -O data/Details_Paid_2020.xlsx

$(APPEALS_JSONL_FILE):
	mkdir -p data && wget 'https://wokewindows-data.s3.amazonaws.com/appeals.jsonl.gz' -O $(APPEALS_JSONL_FILE)

$(CITATIONS_CSV):
	mkdir -p data && wget 'https://wokewindows-data.s3.amazonaws.com/boston_pd_citations_with_names_2011_2020.csv' -O $@

EARNINGS_CSV=data/2011_2020_bpd_earnings_with_ids.csv
$(EARNINGS_CSV):
	mkdir -p data && wget 'https://wokewindows-data.s3.amazonaws.com/2011_2020_bpd_earnings_with_ids.csv' -O $@

.PHONY: import-appeals
import-appeals: $(APPEALS_JSONL_FILE)
	bundle exec rails r Importer::Appeals.import_all

.PHONY: import-citations
import-citations: $(CITATIONS_CSV)
	bundle exec rails r Importer::Citations.import_all
	bundle exec rails counters:fix

.PHONY: import-earnings
import-earnings: $(EARNINGS_CSV)
	rails r Importer::EmployeeEarnings.import_all
	rails counters:fix
