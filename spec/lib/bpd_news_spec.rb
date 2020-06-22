describe BpdNews do
  it "downloads a pdf" do
    contents = String.new(" "*256, encoding: "ASCII-8BIT")
    (0 ... 256).each do |i| contents.setbyte(i,i) end
    Dir.mktmpdir do |dir|
      bn = BpdNews.new(dir)
      expect(bn).to receive(:get_links).and_return(["http://example.com/foobar.pdf", "http://example.com/?offset=1234"], [])
      expect(bn).to receive(:get_file).and_return(contents)
      bn.crawl
      expect(IO.read("#{dir}/foobar.pdf", mode: "rb")).to eql(contents)
    end
  end
end
