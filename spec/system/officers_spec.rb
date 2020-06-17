require 'rails_helper'

describe "Officers", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "displays an officer" do
    o = Officer.create({employee_id: 1234, hr_name: "Foo,Bar"})
    visit officer_path(o)
    expect(page).to have_text("Foo, Bar")
  end
end
