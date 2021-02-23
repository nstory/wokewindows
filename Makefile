APPEALS_JSONL_FILE=data/appeals.jsonl.gz
DETAILS_PAID_FILES=data/Details_Paid_2017.xlsx data/Details_Paid_2018.xlsx data/Detail_Records_January_to_December_2019.xlsx data/Details_Paid_2020.xlsx

.PHONY: appeals

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

appeals: $(APPEALS_JSONL_FILE)
	bundle exec rails r Importer::Appeals.import_all
