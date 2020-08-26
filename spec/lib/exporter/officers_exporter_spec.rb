describe Exporter::OfficersExporter do
  let(:io) { StringIO.new }
  let(:exporter) { Exporter::OfficersExporter.new }
  let(:records) { CSV.parse(io.string, headers: true) }

  describe "james t kirk" do
    let!(:officer_kirk) { create(:officer_kirk) }

    it "exports" do
      exporter.export(io)
      record = records.first
      expect(record["active"]).to eql("true")
      expect(record["employee_id"]).to eql("1701")
      expect(record["name"]).to eql("Kirk, James T")
      expect(record["doa"]).to eql("2233-03-22")
      # expect(record["earnings_rank"]).to eql("42")
      expect(record["organization"]).to eql("Starfleet")
      expect(record["title"]).to eql("Starship Captain")
      expect(record["badge"]).to eql("4223")
      expect(record["zip_code"]).to eql("02131")
      expect(record["city"]).to eql("Rozzie")
      expect(record["state"]).to eql("MA")
      expect(record["neighborhood"]).to eql("Roslindale")
      expect(record["regular"]).to eql("142061.86")
      expect(record["retro"]).to eql("0.00")
      expect(record["other"]).to eql("21262.85")
      expect(record["overtime"]).to eql("115361.12")
      expect(record["injured"]).to eql("0.00")
      expect(record["detail"]).to eql("41360.00")
      expect(record["quinn"]).to eql("35492.87")
      expect(record["total"]).to eql("355538.70")
      expect(record["rank"]).to eql("capt")
      expect(record["ia_score"]).to eql("4")
      expect(record["field_contacts_count"]).to eql("13")
      expect(record["incidents_count"]).to eql("14")
      expect(record["complaints_count"]).to eql("15")
      expect(record["swats_count"]).to eql("16")
      expect(record["details_count"]).to eql("17")
      expect(record["citations_count"]).to eql("18")
      expect(record["articles_officers_count"]).to eql("19")
    end
  end
end
