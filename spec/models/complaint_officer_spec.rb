describe ComplaintOfficer do
  describe "#severity" do
    {
      "Violation of Criminal Law" => :severe,
      "Directives/Orders" => :concerning,
      "xyzzy" => :less_concerning
    }.each do |allegation, severity|
      it "#{allegation} is #{severity}" do
        co = ComplaintOfficer.new(allegation: allegation)
        expect(co.severity).to eql(severity)
      end
    end
  end

  describe "#normalized_allegation" do
    {
      "Detail Cards (68 counts)" => "Detail Cards",
      "Neg.Duty/Unreasonable Judge" => "Neg.Duty/Unreasonable Judge",
      "Acceptance of Details 6 counts)" => "Acceptance of Details",
      nil => nil
    }.each do |allegation, normalized|
      it "#{allegation} -> #{normalized}" do
        expect(
          ComplaintOfficer.new(allegation: allegation).normalized_allegation
        ).to eql(normalized)
      end
    end
  end
end
