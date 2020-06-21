describe Attribution do
  let(:a) { Attribution.new filename: "a", category: "b", url: "c" }
  let(:b) { Attribution.new filename: "a", category: "b", url: "c" }

  describe ".==" do
    it "equals" do
      expect(a).to eql(b)
    end

    it "does not equal if filenames don't match" do
      b.filename = "x"
      expect(a).to_not eql(b)
    end
  end

  describe ".hash" do
    it "equals" do
      expect(a.hash).to eql(b.hash)
    end
  end

  describe ".friendly_category" do
    it "says Public Journal" do
      a = Attribution.new(category: "district_journal")
      expect(a.friendly_category).to eql("Public Journal")
    end
  end
end
