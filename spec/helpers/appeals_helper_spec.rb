require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the AppealsHelper. For example:
#
# describe AppealsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe AppealsHelper do
  let!(:appeal) { build(:appeal) }
  let!(:norris_appeal) { build(:norris_appeal) }

  it "marks the search term" do
    expect(helper.render_appeal_decision_excerpt(norris_appeal, "omg")).to match(%r{<mark>omg</mark>})
  end

  it "returns the beginning if there's no search" do
    expect(helper.render_appeal_decision_excerpt(norris_appeal, "")).to match(/^lol omg/)
  end

  it "returns N/A if no decisions_text" do
    expect(helper.render_appeal_decision_excerpt(appeal, "foo")).to match(%r{N/A})
  end

  it "returns the beginning if the search doesn't match anything" do
    expect(helper.render_appeal_decision_excerpt(norris_appeal, "foobar")).to match(/^lol omg/)
  end
end
