describe Offense do
  let(:a) { Offense.new code: 123, code_group: "abc", description: "xyz" }
  let(:b) { Offense.new code: 123, code_group: "abc", description: "xyz" }

  describe ".eql?" do
    it "is true" do
      expect(a).to eql(b)
      expect(a).to eq(b)
    end

    it "is not true" do
      b.code = 456
      expect(a).to_not eql(b)
      expect(a).to_not eq(b)
    end
  end

  describe ".hash" do
    it "is equal" do
      expect(a.hash).to eql(b.hash)
    end

    it "is not equal" do
      b.code = 456
      expect(a.hash).to_not eql(b.hash)
    end
  end
end
