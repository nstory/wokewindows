describe ComplaintOfficer do
  describe "severity" do
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
end
