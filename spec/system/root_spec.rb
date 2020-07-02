describe "Root" do
  before { driven_by(:rack_test) }

  it "should display some stuff" do
    visit root_path
    expect(page).to have_link("", href: cases_path)
  end
end
