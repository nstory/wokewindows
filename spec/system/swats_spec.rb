describe "Swats" do
  let!(:swat) { Swat.create(swat_number: "14-LOL", date: "2012-04-01") }

  describe "index" do
    it "should display the swat" do
      visit swats_path
      expect(page).to have_selector("td", text: "14-LOL")
      expect(page).to have_selector("td", text: "Apr 1, 2012")
      expect(page).to have_link("14-LOL", href: /swats.*14-LOL/)
    end
  end

  describe "show" do
    before { driven_by(:rack_test) }
    it "should display the swat" do
      visit swat_path(swat)
      expect(page).to have_content("14-LOL")
      expect(page).to have_content("Apr 1, 2012")
      expect(page).to have_link("Click here to view", href: "https://wokewindows-data.s3.amazonaws.com/swats/14-LOL.pdf")
    end
  end
end
