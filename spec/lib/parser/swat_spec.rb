describe Parser::Swat do
  let(:file) { file_fixture("14-24OCT02.txt" ) }
  let(:parser) { Parser::Swat.new(file) }
  let(:record) { parser.records.first }
  let!(:officer) { Officer.create(employee_id: 93825, hr_name: "Ashman,Steven P") }

  it "parses a record" do
    expect(record[:swat_id]).to eql("14-24OCT02")
    expect(record[:officers]).to include({
      employee_id: "093825",
      name: "Ashman, Steven"
    })
    expect(record[:date]).to eql("2014-10-02")
  end

  it "prefers date from name of file" do
    Tempfile.create("14-42JUNE29.txt") do |tmpfile|
      tmpfile.write(file.read)
      tmpfile.flush
      r = Parser::Swat.new(tmpfile).records.first
      expect(r[:date]).to eql("2014-06-29")
    end
  end

  it "doesn't return a record if name doesn't match" do
    officer.hr_name =  "Xshman,Steven P"
    officer.save
    expect(record[:officers].pluck(:employee_id)).to_not include("093825")
  end

  it "removes cruft from name" do
    officer.hr_name = "Santry,Patrick B"
    officer.employee_id = 2277
    officer.save
    expect(record[:officers]).to include({
      employee_id: "002277",
      name: "Santry, Patrick"
    })
  end

  describe "record with incident number" do
    let(:file) { file_fixture("14-20JULY02.txt") }
    it "parses out any incident numbers" do
      expect(record[:incident_numbers]).to eql(["14-2005278"])
    end
  end
end
