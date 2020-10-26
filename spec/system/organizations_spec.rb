describe "Organizations" do
    let(:org1) { "org1" }
    let(:org2) { "org2" }
    let!(:officers) {
        [
            create(:officer, organization: org1),
            create(:officer_kirk, organization: org2),
        ]
    }

    describe "show" do
      it "shows a count of employees in the organization" do
        visit organization_path(officers[0].organization_param)
        expect(page).to have_text("It has 1 past or present member")
      end
    end

    describe "index" do
      it "displays fields" do
        visit organizations_path
        expect(page).to have_selector("a", text: org1.titleize)
        expect(page).to have_selector("a", text: org2.titleize)
        expect(page).to have_selector("td", text: 1)
      end
    end
  end
