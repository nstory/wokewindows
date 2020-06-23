describe "FieldContacts" do
  describe "index" do
    let!(:field_contact) { FieldContact.create(fc_num: "FC123", contact_officer_name: "KIRK, JAMES") }

    describe "searching" do
      before do
        visit field_contacts_path

        # make sure all field contacts are being shown
        expect(page).to have_selector("td", text: "FC123")

        # make sure all field contacts are filtered out
        fill_in "Search", with: "fleet"
        expect(page).to_not have_selector("td", text: "FC123")
        expect(page).to have_content("No matching records found")
      end

      it "searches name" do
        fill_in "Search", with: "kirk"
        expect(page).to have_selector("td", text: "FC123")
      end
    end
  end
end
