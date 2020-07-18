require 'rails_helper'

describe Article do
  describe "#source" do
    it "returns bpdnews" do
      expect(
        Article.new(url: "https://bpdnews.com/xyzzy").source
      ).to eql("bpdnews.com")
    end

    it "return boston globe" do
      expect(
        Article.new(url: "https://www.bostonglobe.com/sdfdf").source
      ).to eql("Boston Globe")
    end
  end
end
