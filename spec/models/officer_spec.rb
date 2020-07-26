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
end
