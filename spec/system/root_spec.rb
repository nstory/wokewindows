describe "Root" do
  before { driven_by(:rack_test) }

  it "should display some stuff" do
    visit root_path
    expect(page).to have_link("", href: cases_path)
    assert_meta_description(/Boston Police Department/)
    assert_canonical_link("/")
  end
end
