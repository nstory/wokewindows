require 'rails_helper'

describe Article do
  describe "#source" do
    it "returns bpdnews" do
      expect(
        Article.new(url: "https://bpdnews.com/xyzzy").source
      ).to eql("bpdnews.com")
    end
  end
end
