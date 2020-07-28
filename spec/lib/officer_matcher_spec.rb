describe OfficerMatcher do
  let!(:officer) { Officer.create!(hr_name: "Foo,Bar", employee_id: 42) }
  let(:officer_matcher) { OfficerMatcher.new }

  describe "#matches" do
    it "matches the officer present in the text" do
      expect(officer_matcher.matches("Officer Bar Foo lol is a Bar D. Foo")).to eql([officer])
    end

    it "doesn't match the officer not present" do
      expect(officer_matcher.matches("Officer Bar Xoo lol")).to eql([])
    end

    describe "second officer with different middle initial" do
      let!(:officer2) { Officer.create!(hr_name: "Foo,Bar P", employee_id: 43) }
      it "doesn't match if ambiguous" do
        expect(officer_matcher.matches("Officer Bar Foo lol")).to eql([])
      end
    end
  end
end
