describe Officer do
  describe "#article_regexp" do
    def article_regexp(name)
      Officer.new({hr_name: name}).article_regexp
    end

    it "matches jack for john" do
      expect("Jack Bean").to match(article_regexp("Bean,John M"))
    end

    it "matches funny middle name" do
      expect("Lark Hooper").to match(article_regexp("Hooper,D. Lark"))
    end

    it "doesn't match part of word" do
      expect("to Johns Hopkins").to_not match(article_regexp("Ho, John C"))
    end

    it "doesn't match another part of word" do
      expect("in John Fish who, through").to_not match(article_regexp("Ho, John C"))
    end
  end

  describe "#last_first_regexp" do
    def last_first_regexp(name)
      Officer.new({hr_name: name}).last_first_regexp
    end

    it "matches jean-louis" do
      expect("JEAN-LOUIS, JEAN").to match(last_first_regexp("Jean Louis,Jean G."))
    end

    it "does not match hester" do
      expect("Lanchester, Wayne").to_not match(last_first_regexp("Hester,Wayne Emory"))
    end
  end

  describe "#name" do
    it "returns hr_name" do
      expect(Officer.new({hr_name: "Foo,Bar P"}).name).to eql("Foo, Bar P")
    end

    it "returns journal_name if hr_name is not present" do
      expect(Officer.new({journal_name: "FOO BAR"}).name).to eql("Foo Bar")
    end

    it "otherwise Unknown" do
      expect(Officer.new({}).name).to eql("Unknown")
    end
  end

  describe "#first_name_last" do
    it "returns hr_name" do
      expect(Officer.new({hr_name: "Foo,Bar P"}).first_name_last).to eql("Bar P Foo")
    end

    it "returns journal_name" do
      expect(Officer.new({journal_name: "FOO BAR"}).first_name_last).to eql("Foo Bar")
    end
  end

  describe "#name_with_title" do
    it "police officer" do
      expect(Officer.new({hr_name: "Foo,Bar", title: "Police Officer"}).name_with_title).to eql("Officer Bar Foo")
    end

    it "police detective" do
      expect(Officer.new({hr_name: "Foo,Bar", title: "Police Detective"}).name_with_title).to eql("Detective Bar Foo")
    end

    it "nil title" do
      expect(Officer.new({hr_name: "Foo,Bar"}).name_with_title).to eql("Bar Foo")
    end

    it "other title" do
      expect(Officer.new({hr_name: "Foo,Bar", title: "dsf"}).name_with_title).to eql("Bar Foo")
    end

    it "deputy sup" do
      expect(Officer.new({hr_name: "Foo,Bar", title: "Dep Supn (Bpd)"}).name_with_title).to eql("Deputy Supt. Bar Foo")
    end

    it "superintendent" do
      expect(Officer.new({hr_name: "Foo,Bar", title: "Supn Bpd"}).name_with_title).to eql("Supt. Bar Foo")
    end

    it "is civilian supn" do
      expect(Officer.new({hr_name: "Foo,Bar", title: "Supn Auto Maint(Bpdfleet)"}).name_with_title).to eql("Bar Foo")
    end
  end

  describe ".articles_officers_to_review_count" do
    let!(:officer) { Officer.create(hr_name: "Foo,Bar") }

    it "is zero for officer with no articles" do
      expect(officer.articles_officers_to_review_count).to eql(0)
    end
  end

  describe "#calculate_ia_score" do
    let!(:officer) { Officer.create!(employee_id: 123) }

    def complaint(*args)
      Complaint.create!(
        ia_number: SecureRandom.uuid,
        complaint_officers: args.each_slice(2).map do |allegation, finding|
          ComplaintOfficer.new(officer: officer, allegation: allegation, finding: finding)
        end
      )
    end

    it "is 5 for a sustained serious allegation" do
      complaint("Violation of Criminal Law", "Sustained")
      expect(officer.calculate_ia_score).to eql(5)
      Officer.fix_ia_score
      expect(officer.reload.ia_score).to eql(5)
    end

    it "is 4 for 2 sustained concerning cases" do
      2.times {
        complaint("Respectful Treatment", "Sustained")
      }
      expect(officer.calculate_ia_score).to eql(4)
    end

    it "is 4 for 1 sustained use of force case" do
      complaint("Use of Force", "Sustained")
      expect(officer.calculate_ia_score).to eql(4)
    end

    it "is 3 for 1 sustained concerning cases" do
      complaint("Respectful Treatment", "Sustained")
      expect(officer.calculate_ia_score).to eql(3)
    end

    it "is 2 for 1 sustained less-concerning case" do
      complaint("Xyzzy", "Sustained")
      expect(officer.calculate_ia_score).to eql(2)
    end

    it "is 2 for 5 cases regardless of outcome" do
      5.times {
        complaint("Xyzzy", "Unfounded")
      }
      expect(officer.calculate_ia_score).to eql(2)
    end

    it "is 1 for 2 cases regardless of outcome" do
      2.times {
        complaint("Xyzzy", "Unfounded")
      }
      expect(officer.calculate_ia_score).to eql(1)
    end
  end

  describe ".by_employee_id" do
    it "returns a hash of officers" do
      o1 = Officer.create({employee_id: 1234})
      o2 = Officer.create({employee_id: 4567})
      expect(Officer.by_employee_id).to eql({
        1234 => o1,
        4567 => o2
      })
    end
  end

  describe "#to_param" do
    it "returns a URL slug based on an officer's employee_id and name" do
      o = Officer.create({employee_id: 1234, hr_name: 'Bar,Foo P'})
      expect(o.to_param).to eql('1234-foo-p-bar')
    end
  end

  describe "ia" do
    let!(:complaint_officer_kirk) { create(:complaint_officer_kirk) }
    let(:officer_kirk) { complaint_officer_kirk.officer }

    describe "#ia_sustained_neg_duty" do
      it "empty when none" do
        expect(officer_kirk.ia_sustained_neg_duty).to eql([])
      end

      it "has the complaint" do
        complaint_officer_kirk.allegation = "Neg.Duty/Unreasonable Judge"
        complaint_officer_kirk.save
        expect(officer_kirk.ia_sustained_neg_duty).to eql([complaint_officer_kirk.complaint])
      end
    end

    it "#ia_sustained_allegations" do
      expect(officer_kirk.ia_sustained_allegations).to eql([complaint_officer_kirk])
    end

    describe "#ia_complaints" do
      it "one when one" do
        expect(officer_kirk.ia_complaints).to eql([complaint_officer_kirk.complaint])
      end

      it "doesn't count prelim case" do
        complaint_officer_kirk.complaint.incident_type = "Preliminary Investigation"
        complaint_officer_kirk.complaint.save
        expect(officer_kirk.ia_complaints).to eql([])
      end
    end

    describe "#ia_allegations" do
      it "one when one" do
        expect(officer_kirk.ia_allegations).to eql(1)
      end
    end
  end

  describe "#years_of_service" do
    let(:officer) { build(:officer) }
    before do
      travel_to Time.zone.local(2020, 7, 1, 1, 1, 1)
    end

    it "is nil if no doa" do
      expect(officer.years_of_service).to eql(nil)
    end

    it "is 0 if less than one year" do
      officer.doa = "2020-06-29"
      expect(officer.years_of_service).to eql(0)
    end

    it "is 1 if one year" do
      officer.doa = "2019-07-01"
      expect(officer.years_of_service).to eql(1)
    end
  end

  describe "#organization_to_param" do
    ["Youth Violence Strike Force"].each do |org|
      it org do
        o = Officer.new(organization: org)
        expect(Officer.organization_from_param(o.organization_param)).to eql(org)
      end
    end
  end

  describe "organizations" do
    let(:organization) { "Some./ strange! org" }
    let(:organization_param) { "some-strange-org-U29tZS4vIHN0cmFuZ2UhIG9yZw" }
    describe "#organization_to_param" do
      it "generates a well-formatted organization URL slug" do
        expect(Officer.organization_to_param(organization)).to eql(organization_param)
      end
      
      it "handles an empty organization" do
        expect(Officer.organization_to_param(nil)).to eql(nil)
      end
    end

    describe "#organization_from_param" do
      it "parses a well-formatted organization URL slug" do
        expect(Officer.organization_from_param(organization_param)).to eql(organization)
      end

      it "handles a poorly-formatted organization URL slug" do
        expect(Officer.organization_from_param("uh; oh!")).to eql(nil)
      end
    end
  end
end
