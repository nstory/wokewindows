describe Exporter::Officers do
  include_context "exporter"

  describe "james t kirk" do
    let!(:officer_kirk) { create(:officer_kirk) }

    it "exports" do
      export
      expect(record["url"]).to match(/officers\/1701-james/)
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
      expect(record["ia_sustained_conduct_unbecoming"]).to eql("0")
      expect(record["ia_cases"]).to eql("0")
      expect(record["ia_allegations"]).to eql("0")
      expect(record["lead_added"]).to eql("2012-06-29")
      expect(record["lead_entry"]).to eql("stole a Klingon Bird of Prey")
    end

    describe "with pension data" do
      let!(:pension) { create(:pension, officer: officer_kirk) }

      it "exports" do
        export
        expect(record["retirement_date"]).to eql("2020-06-29")
        expect(record["retirement_amount"]).to eql("1234.56")
      end
    end
  end
end
