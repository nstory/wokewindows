describe "FieldContacts" do
  let!(:citation) { Citation.create!(ticket_number: "T1234567") }
  let!(:incident) { Incident.create!(incident_number: "123456789") }
  let!(:field_contact) { FieldContact.create!(fc_num: "FC123", contact_officer_name: "KIRK, JAMES", zip: 2131, incidents: [incident], citations: [citation], narrative: "foo bar\n\nlol I123456789\n\nbar T1234567") }

  describe "index" do
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

      it "searches fc_num" do
        fill_in "Search", with: "FC123"
        expect(page).to have_selector("td", text: "FC123")
      end

      it "searches zip" do
        fill_in "Search", with: "02131"
        expect(page).to have_selector("td", text: "FC123")
      end
    end
  end

  describe "show" do
    before { driven_by(:rack_test) }

    it "displays some fields" do
      visit field_contact_path(field_contact)
      expect(page).to have_selector("dd", text: "FC123")
      expect(page).to have_selector("dd", text: "KIRK, JAMES")
      expect(page).to have_selector("dd", text: "02131")
      expect(page).to have_link("I123456789", href: incident_path(incident))
      expect(page).to have_link("T1234567", href: citation_path(citation))
    end
  end
end
