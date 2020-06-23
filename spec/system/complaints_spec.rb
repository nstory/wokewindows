describe "Complaints" do
  describe "index" do
    let(:complaint_officer) { ComplaintOfficer.new(name: "Ptl James Kirk") }
    let!(:complaint) { Complaint.create(ia_number: "123", summary: "foobar", complaint_officers: [complaint_officer]) }
    describe "searching" do
      before do
        visit complaints_path

        # make sure all incidents are being shown
        expect(page).to have_selector("td", text: "123")

        # make sure all incidents are filtered out
        fill_in "Search", with: "lolroflcopter"
        expect(page).to_not have_selector("td", text: "123")
        expect(page).to have_content("No matching records found")
      end

      it "searches summary" do
        fill_in "Search", with: "foobar"
        expect(page).to have_selector("td", text: "123")
      end

      it "searches officer name" do
        fill_in "Search", with: "kirk"
        expect(page).to have_selector("td", text: "123")
      end
    end
  end
end
