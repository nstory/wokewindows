describe Importer::Contributions do
  let(:records) { [record] }
  let(:attribution) { Attribution.new filename: "a", category: "b", url: nil }
  let(:parser) { mock_parser(records, attribution) }
  let(:importer) { Importer::Contributions.new(parser, clazz) }
  let!(:officer_kirk) { create(:officer_kirk) }

  describe "ocpf record" do
    let(:record) {{
      :date=>"4/20/2004",
      :contributor=>"Kirk, James T",
      :city=>"Winthrop",
      :state=>"MA",
      :zip=>"02152",
      :occupation=>"Law Enforcement",
      :employer=>"City of Boston",
      :principal_officer=>"",
      :amount=>"$25.00",
      :cpf_id=>"11470",
      :recipient=>"Travaglini, Robert E.",
      :tender_type_id=>"0",
      :tender_type_description=>"Not Specified",
      :record_type_id=>"201",
      :record_type_description=>"Individual",
      :source_description=>"2004 Pre-primary Report (ND)",
      :comm_name=>"Travaglini Committee",
      :party_affiliation=>"Democratic",
      :candidate_full_name=>"Robert E. Travaglini",
      :office_type=>"Senate",
      :district=>"1st Suffolk & Middlesex"
    }}
    let(:clazz) { OcpfContribution }

    it "imports a record" do
      importer.import
      c = Contribution.first
      expect(c).to be_a(OcpfContribution)
      expect(c.date).to eql("2004-04-20")
      expect(c.contributor).to eql("Kirk, James T")
      expect(c.zip).to eql(2152)
      expect(c.amount).to eql(25.0)
      expect(c.cpf_id).to eql(11470)
      expect(c.candidate_full_name).to eql("Robert E. Travaglini")
      expect(c.office_type).to eql("Senate")
      expect(c.district).to eql("1st Suffolk & Middlesex")
      expect(c.party_affiliation).to eql("Democratic")
      expect(c.occupation).to eql("Law Enforcement")
      expect(c.employer).to eql("City of Boston")
      expect(c.officer).to eql(officer_kirk)
      expect(c.committee_name).to eql("Travaglini Committee")
    end

    it "doesn't import twice" do
      2.times { importer.import }
      expect(Contribution.count).to eql(1)
    end

    it "matches middle name in officer not in contribution" do
      record[:contributor] = "Kirk, James"
      importer.import
      expect(Contribution.first.officer).to eql(officer_kirk)
    end

    it "matches middle name in contribution not officer" do
      officer_kirk.hr_name = "Kirk, James"
      officer_kirk.save
      importer.import
      expect(Contribution.first.officer).to eql(officer_kirk)
    end

    it "matches if there's a year in the contributor name" do
      record[:contributor] = "Kirk 2019, James"
      importer.import
      expect(Contribution.first.officer).to eql(officer_kirk)
    end
  end

  describe "fec record" do
    let(:record) {{
      :committee_id=>"C00366948",
      :committee_name=>"STEPHEN F. LYNCH FOR CONGRESS COMMITTEE",
      :report_year=>"2004",
      :report_type=>"30G",
      :image_number=>"24991477537",
      :line_number=>"11AI",
      :transaction_id=>"SA11A1.154239",
      :file_number=>"156339",
      :entity_type=>"IND",
      :entity_type_desc=>"INDIVIDUAL",
      :unused_contbr_id=>"",
      :contributor_prefix=>"",
      :contributor_name=>"KIRK, JAMES T",
      :recipient_committee_type=>"H",
      :recipient_committee_org_type=>"",
      :recipient_committee_designation=>"P",
      :contributor_first_name=>"JOHN C",
      :contributor_middle_name=>"",
      :contributor_last_name=>"DAILEY",
      :contributor_suffix=>"",
      :contributor_street_2=>"",
      :contributor_city=>"BRAINTREE",
      :contributor_state=>"MA",
      :contributor_zip=>"2184",
      :contributor_employer=>"CITY OF BOSTON",
      :contributor_occupation=>"POLICE OFFICER",
      :contributor_id=>"",
      :receipt_type=>"15",
      :receipt_type_desc=>"CONTRIBUTION",
      :receipt_type_full=>"da type full",
      :memo_code=>"",
      :memo_code_full=>"",
      :contribution_receipt_date=>"11/1/04 0:00",
      :contribution_receipt_amount=>"500",
      :contributor_aggregate_ytd=>"590",
      :candidate_id=>"",
      :candidate_name=>"",
      :candidate_first_name=>"",
      :candidate_last_name=>"",
      :candidate_middle_name=>"",
      :candidate_prefix=>"",
      :candidate_suffix=>"",
      :candidate_office=>"",
      :candidate_office_full=>"",
      :candidate_office_state=>"",
      :candidate_office_state_full=>"",
      :candidate_office_district=>"",
      :conduit_committee_id=>"",
      :conduit_committee_name=>"",
      :conduit_committee_street1=>"",
      :conduit_committee_street2=>"",
      :conduit_committee_city=>"",
      :conduit_committee_state=>"",
      :conduit_committee_zip=>"",
      :donor_committee_name=>"",
      :national_committee_nonfederal_account=>"",
      :election_type=>"G2004",
      :election_type_full=>"",
      :fec_election_type_desc=>"GENERAL",
      :fec_election_year=>"2004",
      :amendment_indicator=>"N",
      :amendment_indicator_desc=>"NO CHANGE",
      :schedule_type_full=>"ITEMIZED RECEIPTS",
      :load_date=>"55:41.5",
      :original_sub_id=>"",
      :back_reference_transaction_id=>"",
      :back_reference_schedule_name=>"",
      :filing_form=>"F3",
      :link_id=>"4.12102E+18",
      :is_individual=>"t",
      :memo_text=>"da memo",
      :two_year_transaction_period=>"2004",
      :schedule_type=>"SA",
      :increased_limit=>"",
      :sub_id=>"4.12172E+18",
      :pdf_url=>"http://docquery.fec.gov/cgi-bin/fecimg/?24991477537",
      :line_number_label=>"Contributions From Individuals/Persons Other Than Political Committees"
    }}
    let(:clazz) { FecContribution }

    it "imports the record" do
      importer.import
      c = Contribution.first
      expect(c).to be_a(FecContribution)
      expect(c.date).to eql("2004-11-01")
      expect(c.contributor).to eql("KIRK, JAMES T")
      expect(c.zip).to eql(2184)
      expect(c.amount).to eql(500)
      expect(c.occupation).to eql("POLICE OFFICER")
      expect(c.employer).to eql("CITY OF BOSTON")
      expect(c.committee_name).to eql("STEPHEN F. LYNCH FOR CONGRESS COMMITTEE")
      expect(c.committee_id).to eql("C00366948")
      expect(c.memo_text).to eql("da memo")
      expect(c.receipt_type_full).to eql("da type full")
      expect(c.officer).to eql(officer_kirk)
      expect(c.party_affiliation).to eql("Democratic")
    end

    it "raises an error if unknown committee_id" do
      record[:committee_id] = "xyzzy"
      expect { importer.import }.to raise_error(KeyError)
    end

    it "eight digit zip" do
      record[:contributor_zip] = "21322923"
    end
  end
end
