describe "Pages" do
  describe "about" do
    it "links to personal github" do
      visit page_path("about")
      expect(page).to have_link("@nstory", href: "https://github.com/nstory")
    end
  end

  describe "help" do
    it "has internal affairs page" do
      visit help_path("internal_affairs")
      expect(page).to have_content("Internal Affairs")
    end
  end
end
