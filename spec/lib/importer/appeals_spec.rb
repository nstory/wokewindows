describe Importer::Appeals do
  include_context "importer"

  let(:record) {{
    :case_type=>"Appeal",
    :case_subtype=>"Reconsideration",
    :status=>"Closed",
    :case_no=>"20192106",
    :appeal_no => "xyzzy",
    :requester=>"Norris, Chuck",
    :custodian=>"Executive Office of Public Safety and Security - Massachusetts Parole Board",
    :req_rec_date=>"8/19/2019",
    :resp_prov_date=>"8/30/2019",
    :fees=>"0.00",
    :petitions=>"No",
    :comply=>"6 business days",
    :date_opened=>"10/15/2019",
    :date_closed=>"10/29/2019",
    :reconsider_open_date=>"12/13/2019",
    :reconsider_close_date=>"1/7/2020",
    :in_cam_open_date=>"11/6/2019",
    :in_cam_close_date=>"11/29/2019",
    :request_to_court=>"No",
    :files => [
      {path: "foo/bar", text: "lol"},
      {path: "foz/baz", text: "lmao"}
    ]
  }}

  it "imports a record" do
    importer.import
    appeal = Appeal.first
    expect(appeal.case_type).to eql("Appeal")
    expect(appeal.case_subtype).to eql("Reconsideration")
    expect(appeal.status).to eql("Closed")
    expect(appeal.case_no).to eql("20192106")
    expect(appeal.appeal_no).to eql("xyzzy")
    expect(appeal.requester).to eql("Norris, Chuck")
    expect(appeal.custodian).to eql("Executive Office of Public Safety and Security - Massachusetts Parole Board")
    expect(appeal.req_rec_date).to eql("2019-08-19")
    expect(appeal.resp_prov_date).to eql("2019-08-30")
    expect(appeal.fees).to eql(0)
    expect(appeal.petitions).to eql(false)
    expect(appeal.comply).to eql("6 business days")
    expect(appeal.date_opened).to eql("2019-10-15")
    expect(appeal.date_closed).to eql("2019-10-29")
    expect(appeal.reconsider_open_date).to eql("2019-12-13")
    expect(appeal.reconsider_close_date).to eql("2020-01-07")
    expect(appeal.in_cam_open_date).to eql("2019-11-06")
    expect(appeal.in_cam_close_date).to eql("2019-11-29")
    expect(appeal.request_to_court).to eql(false)
    expect(appeal.decisions_text).to match(/lol/)
    expect(appeal.decisions_text).to match(/lmao/)
    expect(appeal.decision_urls).to include("https://wokewindows-data.s3.amazonaws.com/appeals/foo/bar")
  end

  it "updates existing appeal" do
    appeal = Appeal.new(case_no: "20192106")
    appeal.save
    importer.import
    expect(appeal.reload.case_subtype).to eql("Reconsideration")
  end
end
