describe "Appeals" do
  let!(:appeal) { create(:appeal) }
  let!(:norris_appeal) { create(:norris_appeal) }

  describe "index" do
    it "shows appeal" do
      visit appeals_path
      click_button "Search"
      expect(page).to have_link("20200042", href: appeal_path(appeal))
      expect(page).to have_link("", href: "https://test.wokewindows.org/foobar.pdf" )
    end
  end

  describe "show" do
    it "shows appeal" do
      visit appeal_path(appeal)
      expect(page).to have_content("20200042")
    end

    it "shows norris appeal" do
      visit appeal_path(norris_appeal)
      expect(page).to have_selector("dd", text: "Appeal")
      expect(page).to have_selector("dd", text: "Reconsideration")
      expect(page).to have_selector("dd", text: "Closed")
      expect(page).to have_selector("dd", text: "20192106")
      expect(page).to have_selector("dd", text: "Norris, Chuck")
      expect(page).to have_selector("dd", text: "Executive Office of Public Safety and Security - Massachusetts Parole Board")
      expect(page).to have_selector("dd", text: "Aug 19, 2019")
      expect(page).to have_selector("dd", text: "Aug 30, 2019")
      expect(page).to have_selector("dd", text: "0.00")
      expect(page).to have_selector("dd", text: "No")
      expect(page).to have_selector("dd", text: "6 business days")
      expect(page).to have_selector("dd", text: "Oct 15, 2019")
      expect(page).to have_selector("dd", text: "Oct 29, 2019")
      expect(page).to have_selector("dd", text: "Dec 13, 2019")
      expect(page).to have_selector("dd", text: "Jan 7, 2020")
      expect(page).to have_selector("dd", text: "Nov 6, 2019")
      expect(page).to have_selector("dd", text: "Nov 29, 2019")
      expect(page).to have_selector("dd", text: "No")
      expect(page).to have_link(href: "https://www.sec.state.ma.us/AppealsWeb/AppealStatusDetail.aspx?AppealNo=xyzzy")
    end
  end
end
