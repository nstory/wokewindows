describe "FieldContacts" do
  let!(:citation) { Citation.create!(ticket_number: "T1234567") }
  let!(:incident) { Incident.create!(incident_number: "123456789") }
  let(:field_contact_name) { FieldContactName.new(fc_num: "FC123", gender: "woman", race: "white") }
  let!(:field_contact) { FieldContact.create!(fc_num: "FC123", contact_officer_name: "james kirk", zip: 2131, incidents: [incident], citations: [citation], stop_duration: "thirty_to_forty_five_minutes", narrative: "foo bar\n\nlol i123456789\n\nbar t1234567", field_contact_names: [field_contact_name]) }

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

    it "displays the record" do
      visit field_contacts_path
      expect(page).to have_selector("td", text: "James Kirk")
      expect(page).to have_selector("td", text: "30m - 45m")
    end
  end

  describe "show" do
    before { driven_by(:rack_test) }

    it "displays some fields" do
      visit field_contact_path(field_contact)
      expect(page).to have_selector("dd", text: "FC123")
      expect(page).to have_selector("dd", text: "James Kirk")
      expect(page).to have_selector("dd", text: "02131")
      expect(page).to have_selector("dd", text: "30m - 45m")
      expect(page).to have_link("i123456789", href: incident_path(incident))
      expect(page).to have_link("T1234567", href: citation_path(citation))

      # FieldContactName
      expect(page).to have_selector("td", text: "Woman")
      expect(page).to have_selector("td", text: "White")
    end
  end
end
