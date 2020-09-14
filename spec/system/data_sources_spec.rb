describe "DataSources" do
  before { driven_by(:rack_test) }

  it "shows a data source" do
    visit data_source_path("alpha_listing")
    expect(page).to have_selector("h1", text: "BPD Alpha Listing with Badges")
  end
end
