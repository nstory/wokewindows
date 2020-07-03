require 'rails_helper'

describe Import do
  let(:agent) { spy("spy") }

  it "does an action" do
    Import.import_once("foobar") do
      agent.doit
    end
    expect(agent).to have_received(:doit)
    expect(Import.first.name).to eql("foobar")
  end

  it "doesn't do an action that has been done" do
    Import.create(name: "foobar")
    Import.import_once("foobar") do
      agent.doit
    end
    expect(agent).to_not have_received(:doit)
  end
end
