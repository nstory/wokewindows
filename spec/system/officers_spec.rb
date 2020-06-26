describe "Officers" do
  describe "show" do
    before do
      driven_by(:rack_test)
    end

    it "displays an officer" do
      o = Officer.create({employee_id: 1234, hr_name: "Foo,Bar"})
      visit officer_path(o)
      expect(page).to have_text("Foo, Bar")
    end
  end

  describe "index" do
    let!(:officer) { Officer.create(employee_id: 42, hr_name: "Kirk,James T", zip_code: ZipCode.new(zip: 2228)) }
    describe "searching" do
      before do
        visit officers_path

        # make sure all officers are being shown
        expect(page).to have_selector("td", text: "42")

        # make sure all officers are filtered out
        fill_in "Search", with: "lolroflcopter"
        expect(page).to_not have_selector("td", text: "42")
        expect(page).to have_content("No matching records found")
      end

      it "searches name" do
        fill_in "Search", with: "Kirk"
        expect(page).to have_selector("td", text: "42")
      end

      it "searches neighborhood" do
        fill_in "Search", with: "East Boston"
        expect(page).to have_selector("td", text: "42")
        expect(page).to have_selector("td", text: "East Boston")
      end
    end
  end
end
