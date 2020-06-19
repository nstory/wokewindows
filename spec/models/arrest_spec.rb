describe Arrest do
  describe ".redact!" do
    it "X's out the name" do
      arrest = Arrest.new(name: "KIRK, JAMES")
      arrest.redact!
      expect(arrest.name).to eql("KXXX, JXXXX")
    end

    it "is okay if name is nil" do
      arrest = Arrest.new()
      arrest.redact!
      expect(arrest.name).to eql(nil)
    end
  end
end
