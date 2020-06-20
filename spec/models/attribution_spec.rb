describe Attribution do
  describe "==" do
    let(:a) { Attribution.new filename: "a", category: "b", url: "c" }
    let(:b) { Attribution.new filename: "a", category: "b", url: "c" }
    it "equals" do
      expect(a).to eql(b)
    end

    it "does not equal if filenames don't match" do
      b.filename = "x"
      expect(a).to_not eql(b)
    end
  end
end
