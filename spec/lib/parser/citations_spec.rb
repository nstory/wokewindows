describe Parser::Citations do
  include_context "parser"
  let(:file) { file_fixture("sample_citations.csv") }

  it "parses a record" do
    expect(record[:officer_id]).to eql("11519")
    expect(record[:"16_pass"]).to eql("Unk")
    expect(record[:ticket_num]).to eql("R1118733")
    expect(record[:type]).to eql("CIVIL")
    # expect(record[:source]).to eql("xxx")
    expect(record[:violator_type]).to eql("OPERATOR")
    expect(record[:class]).to eql("D")
    # expect(record[:location_id]).to eql("xxx")
    expect(record[:violation_speed]).to eql("0")
    # expect(record[:assessment]).to eql("xxx")
    # expect(record[:expected_assessmnt]).to eql("xxx")
    # expect(record[:display_assessmnt]).to eql("xxx")
    expect(record[:disposition_desc]).to eql("Pending Finding")
    # expect(record[:criminial]).to eql("xxx")
    # expect(record[:major_indc]).to eql("xxx")
    # expect(record[:sdip_points]).to eql("xxx")
    # expect(record[:surchargeable]).to eql("xxx")
    expect(record[:sex]).to eql("MALE")
    expect(record[:vehicle_color]).to eql("")
    expect(record[:make]).to eql("")
    expect(record[:model_yr]).to eql("0")
    expect(record[:haz_mat]).to eql("No")
    expect(record[:paid]).to eql("N")
    # expect(record[:age]).to eql("xxx")
    expect(record[:hearing_requested]).to eql("Y")
  end
end
