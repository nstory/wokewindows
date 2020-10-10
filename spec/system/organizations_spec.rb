describe "Organizations" do
    let(:org1) { "org1" }
    let(:org2) { "org2" }
    let!(:officers) {
        [
            create(:officer, organization: :org1),
            create(:officer_kirk, organization: :org2),
        ]
    }

    describe "show" do
      it "shows a count of employees in the organization" do
        visit organization_path(:org1)
        expect(page).to have_text("It has 1 past or present member")
      end
    end

    describe "index" do
      it "searches the organization field" do
          visit organizations_path
          fill_in "Search", with: org1
          expect(page).to have_selector("td", text: :org1)
          expect(page).not_to have_selector("td", text: :org2)
          # Also, test that counts seem to work correctly
          expect(page).to have_text("Showing 1 entries (filtered from 2 total entries)")
      end

      it "displays fields" do
        visit organizations_path
        expect(page).to have_selector("td", text: :org1)
        expect(page).to have_selector("td", text: :org2)
        expect(page).to have_selector("td", text: 1)
      end
    end
  end
