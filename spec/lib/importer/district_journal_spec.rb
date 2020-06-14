describe Importer::DistrictJournal do
  let(:record) {{
    officer: "099790  JAMES KIRK"
  }}

  it "imports an officer" do
    Importer::DistrictJournal.import([record])
    officer = Officer.last
    expect(officer.employee_id).to eql(99790)
    expect(officer.journal_name).to eql("JAMES KIRK")
  end

  it "updates an existing record" do
    Officer.create({employee_id: 99790})
    Importer::DistrictJournal.import([record])
    expect(Officer.count).to eql(1)
    expect(Officer.last.journal_name).to eql("JAMES KIRK")
  end

  it "imports the same officer twice" do
    Importer::DistrictJournal.import([record, record])
    expect(Officer.count).to eql(1)
  end

  it "it doesn't import a non-numeric id" do
    Importer::DistrictJournal.import([{officer: "4242L  XX YY"}])
    expect(Officer.count).to eql(0)
  end

  it "chooses most popular if multiple names with same id" do
    Importer::DistrictJournal.import([
      {officer: "099790  LOL ROFL"},
      record, record, record,
      {officer: "099790  LOL ROFL"}
    ])
    expect(Officer.count).to eql(1)
    expect(Officer.last.journal_name).to eql("JAMES KIRK")
  end
end
