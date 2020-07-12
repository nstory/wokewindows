require 'rails_helper'

describe Citation do
  describe "#court_name" do
    it "returns court_code if weird court" do
      expect(Citation.new(court_code: "xyzzy123").court_name).to eql("xyzzy123")
    end

    it "returns court name" do
      expect(Citation.new(court_code: "CT_007").court_name).to eql("Dorchester BMC")
    end
  end
end
