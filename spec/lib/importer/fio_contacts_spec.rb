describe Importer::FioContacts do
  let(:record) {{
    :supervisor=>"106714",
    :fc_num=>"FC19001280",
    :contact_officer_name=>"john f alves",
    :supervisor_name=>"shana cottone",
    :city=>"roslindale",
    :stop_duration=>"less than five minutes",
    :zip=>"02131",
    :basis=>"reasonable suspicion",
    :summonsissued=>"y",
    :vehicle_color=>"red",
    :vehicle_make=>"honda",
    :state=>"ma",
    :vehicle_state=>"vt",
    :vehicle_year=>"2019",
    :circumstance=>"stopped",
    :contact_officer=>"99822",
    :vehicle_style=>"xyzzy",
    :searchvehicle=>"y",
    :vehicle_type=>"school bus",
    :vehicle_model=>"lol",
    :contact_date=>"2019-11-19 10:15:00",
    :street=>"washington st",
    :key_situations=>" body worn camera, homeless",
    :weather=>"other",
    :narrative=>
    "at approximately 10:15 a.m. on tuesday, november 19, 2019, members of y.v.s.f officers alves and j. araujo in the vk11 unit and working under the supervision of sgt. mason, did conduct a threshold inquiry of xxx at xxx washington st, roslindale ma,\n\n \n\nspecifically, mr. xxx was briefly stopped after matching a description of a wanted suspect, he was fio'd and released.",
      :fc_involved_frisk_or_search=>"y",
      :year=>"2019"
  }}
  let(:records) { [record] }
  let(:attribution) { Attribution.new filename: "a", category: "b", url: "c" }
  let(:parser) { mock_parser(records, attribution) }
  let(:importer) { Importer::FioContacts.new(parser) }

  it "imports record" do
    importer.import
    fc = FieldContact.first
    expect(fc.fc_num).to eql("FC19001280")
    expect(fc.supervisor_employee_id).to eql(106714)
    expect(fc.supervisor_name).to eql("shana cottone")
    expect(fc.contact_officer_employee_id).to eql(99822)
    expect(fc.contact_officer_name).to eql("john f alves")
    expect(fc.city).to eql("roslindale")
    expect(fc.stop_duration).to eql("less_than_five_minutes")
    expect(fc.zip).to eql(2131)
    expect(fc.basis).to eql("reasonable_suspicion")
    expect(fc.summons_issued).to eql(true)
    expect(fc.vehicle_color).to eql("red")
    expect(fc.vehicle_make).to eql("honda")
    expect(fc.state).to eql("ma")
    expect(fc.vehicle_state).to eql("vt")
    expect(fc.vehicle_year).to eql(2019)
    expect(fc.circumstance).to eql("stopped")
    expect(fc.vehicle_style).to eql("xyzzy")
    expect(fc.vehicle_type).to eql("school bus")
    expect(fc.vehicle_model).to eql("lol")
    expect(fc.contact_date).to eql("2019-11-19 10:15:00")
    expect(fc.street).to eql("washington st")
    expect(fc.key_situations).to eql(["body worn camera", "homeless"])
    expect(fc.weather).to eql("other")
    expect(fc.narrative).to match(/inquiry of xxx/)
    expect(fc.frisked_searched).to eql(true)
    expect(fc.search_vehicle).to eql(true)
    expect(fc.attributions).to eql([attribution])
  end

  it "connects the contact officer" do
    o = Officer.create!({employee_id: 99822})
    importer.import
    expect(FieldContact.first.contact_officer).to eql(o)
  end

  it "connects the supervisor" do
    o = Officer.create!({employee_id: 106714})
    importer.import
    expect(FieldContact.first.supervisor).to eql(o)
  end
end
