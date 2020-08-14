describe Parser::NibrsIncidentReports do
    let(:file) { file_fixture("sample_boston_nibrs_foia.csv") }
    let(:parser) { Parser::NibrsIncidentReports.new(file) }
    let(:records) { parser.records }
    let(:attribution) { parser.attribution }
  
    it "parses a record" do
      record = records.first
      expect(record[:incident_number]).to eql("192092484")
    end
  
    it "parses all the records" do
      expect(records.count).to eql(99)
    end
  
    it "attributes" do
      expect(attribution.filename).to eql("sample_boston_nibrs_foia.csv")
      expect(attribution.category).to eql("nibrs_incident_reports")
      expect(attribution.url).to eql(nil)
    end
  end
  