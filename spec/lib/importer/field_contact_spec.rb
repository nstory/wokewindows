describe Importer::FieldContact do
  let(:mark43_record) {{
    :fc_num=>"FC19000622",
    :contact_date=>"2019-10-19 0:02:00",
    :contact_officer=>"153458",
    :contact_officer_name=>"PEGUERO, BENIS",
    :supervisor=>"12114",
    :supervisor_name=>"JOHN EARLEY",
    :street=>"FAWNDALE RD",
    :city=>"ROSLINDALE",
    :state=>"MA",
    :zip=>"02131",
    :stop_duration=>"NULL",
    :circumstance=>"Encountered",
    :basis=>"Reasonable Suspicion",
    :vehicle_year=>"NULL",
    :vehicle_state=>"NULL",
    :vehicle_model=>"NULL",
    :vehicle_color=>"NULL",
    :vehicle_style=>"NULL",
    :vehicle_type=>"NULL",
    :key_situations=>"Shots Fired",
    :narrative=>
    "About 12:04 AM, On Saturday, 10/19/2019, Officer Peguero and Officer Ho, of the E202A, received a radio call for Shots Fired at the laundry room of XXXFawndale Rd. Boston, MA\n\nThe caller informed dispatched there were 3 males and 1 female inside the laundry room and that the caller heard a possible shot or fire cracker.\n\n \n\nUpon arrival Officers encountered 5 male subjects and 2 female subjects inside the dark laundry room. Do to the nature of the call, dark room, and with some parties hand inside there pockets, Officers had there weapons drawn in the low ready position. Officers ordered all parties to exit the laundry room, with there hands up and lined them up against the exterior wall. All parties, including the laundry room, with the assistance of L912A, E414A, E427A, EG01A, were frisked for weapons. Liquor bottles and a loud portable speaker were found inside the laundry room, but no weapons or ballistic evidence were found. All parties were identified and released.",
      :weather=>"NULL"
  }}

  let(:rms_record) {{
    :fc_num=>"F190047193",
    :contact_date=>"2019-08-14 18:44:00.0",
    :contact_officer=>"102679",
    :contact_officer_name=>"D'ADDIECO,SANTINO S",
    :supervisor=>"009039",
    :supervisor_name=>"WALSH, BRENDAN",
    :street=>"",
    :city=>"BSTN",
    :state=>"MA",
    :zip=>"02111",
    :frisked=>"",
    :searchperson=>"",
    :searchvehicle=>"",
    :summonsissued=>"",
    :stop_duration=>"Five to Ten Minutes",
    :circumstance=>"Observed",
    :basis=>"Intel",
    :vehicle_year=>"",
    :vehicle_state=>"",
    :vehicle_make=>"xyzzy",
    :vehicle_model=>"",
    :vehicle_color=>"",
    :vehicle_style=>"",
    :vehicle_type=>"",
    :contact_reason=> "OBSERVED IN THE AREA OF WASHINGTON STREET BY TEMPLE PLACE. KNOWN H-BLOCK MEMBERS XXX AND XXX WHO BOTH ARE KNOWN TO BE ACTIVE AROUND FIREARMS AND FIREARM VIOLENCE. BRIC POSTING 19-105 HAS XXX POSSIBLY INVOLVED IN A XXX AT XXX HUTCHINGS ST AND MAY BE IN POSSESSION OF A F/A.\n\nPO D'ADDIECO/MCGAHAN"
  }}

  let(:attribution) { Attribution.new filename: "a", category: "b", url: "c" }
  let(:parser) { mock_parser(records, attribution) }
  let(:importer) { Importer::FieldContact.new(parser) }

  describe "mark43 record" do
    let(:records) { [mark43_record] }

    it "imports a record" do
      importer.import
      fc = FieldContact.first
      expect(fc.fc_num).to eql("FC19000622")
      expect(fc.contact_date).to eql("2019-10-19 00:02:00")
      expect(fc.contact_officer_employee_id).to eql(153458)
      expect(fc.contact_officer_name).to eql("PEGUERO, BENIS")
      expect(fc.supervisor_employee_id).to eql(12114)
      expect(fc.supervisor_name).to eql("JOHN EARLEY")
      expect(fc.street).to eql("FAWNDALE RD")
      expect(fc.city).to eql("ROSLINDALE")
      expect(fc.state).to eql("MA")
      expect(fc.zip).to eql(2131)
      expect(fc.stop_duration).to eql(nil)
      expect(fc.circumstance).to eql("Encountered")
      expect(fc.basis).to eql("Reasonable Suspicion")
      expect(fc.vehicle_year).to eql(nil)
      expect(fc.vehicle_state).to eql(nil)
      expect(fc.vehicle_model).to eql(nil)
      expect(fc.vehicle_color).to eql(nil)
      expect(fc.vehicle_style).to eql(nil)
      expect(fc.vehicle_type).to eql(nil)
      expect(fc.key_situations).to eql(["Shots Fired"])
      expect(fc.weather).to eql(nil)
      expect(fc.attributions).to eql([attribution])
    end

    it "creates one record if record imported twice" do
      2.times { importer.import }
      expect(FieldContact.count).to eql(1)
    end
  end

  describe "rms record" do
    let(:records) { [rms_record] }

    it "imports an rms record" do
      importer.import
      fc = FieldContact.first
      expect(fc.fc_num).to eql("F190047193")
      expect(fc.contact_date).to eql("2019-08-14 18:44:00")
      expect(fc.contact_officer_employee_id).to eql(102679)
      expect(fc.contact_officer_name).to eql("D'ADDIECO,SANTINO S")
      expect(fc.supervisor_employee_id).to eql(9039)
      expect(fc.supervisor_name).to eql("WALSH, BRENDAN")
      expect(fc.street).to eql(nil)
      expect(fc.city).to eql("BSTN")
      expect(fc.state).to eql("MA")
      expect(fc.zip).to eql(2111)
      expect(fc.frisked_searched).to eql(false)
      expect(fc.stop_duration).to eql(5)
      expect(fc.circumstance).to eql("Observed")
      expect(fc.basis).to eql("Intel")
      expect(fc.vehicle_year).to eql(nil)
      expect(fc.vehicle_state).to eql(nil)
      expect(fc.vehicle_make).to eql("xyzzy")
      expect(fc.vehicle_model).to eql(nil)
      expect(fc.vehicle_color).to eql(nil)
      expect(fc.vehicle_style).to eql(nil)
      expect(fc.vehicle_type).to eql(nil)
      expect(fc.narrative).to match(/^OBSERVED.*MCGAHAN$/m)
    end

    it "imports an rms record with weird date" do
      rms_record[:contact_date] = "1/12/2017 10:15"
      importer.import
      fc = FieldContact.first
      expect(fc.contact_date).to eql("2017-01-12 10:15:00")
    end
  end
end
