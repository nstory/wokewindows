describe ComplaintsHelper do
  let(:complaint_officer) { create(:complaint_officer) }

  describe "format_action_taken" do
    it "is blank by default" do
      expect(helper.format_action_taken(complaint_officer)).to eql("")
    end

    it "is N/A if finding is Sustained and action_taken is empty" do
      complaint_officer.finding = "Sustained"
      expect(helper.format_action_taken(complaint_officer)).to match(%r{N/A})
    end

    it "displays action_taken" do
      complaint_officer.action_taken = ["foo", "bar"]
      expect(helper.format_action_taken(complaint_officer)).to match("foo, bar")
    end
  end
end
