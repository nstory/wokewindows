require 'rails_helper'

describe Geocode do
  describe ".geocode_intersection" do
    it "returns nil if either argument is nil" do
      expect(Geocode.geocode_intersection("foo", nil)).to eql(nil)
      expect(Geocode.geocode_intersection(nil, "bar")).to eql(nil)
    end

    it "searches" do
      expect(Geocoder).to receive(:search).with("bar st and foo st, boston, ma", hash_including(lookup: :geocoder_ca)).and_return([OpenStruct.new(latitude: 12.34, longitude: 56.78)])
      gc = Geocode.geocode_intersection("FOO ST", "BAR ST")
      expect(gc.latitude).to eql(12.34)
      expect(gc.longitude).to eql(56.78)
    end
  end

  describe ".geocode_address" do
    it "returns nil if either arugment is nil" do
      expect(Geocode.geocode_address("foo", nil)).to eql(nil)
      expect(Geocode.geocode_address(nil, "bar")).to eql(nil)
    end

    it "searches" do
      expect(Geocoder).to receive(:search).with("42 foo st, boston, ma", hash_including(lookup: :nominatim)).and_return([OpenStruct.new(latitude: 12.34, longitude: 56.78)])
      gc = Geocode.geocode_address("FOO ST", "42")
      expect(gc.latitude).to eql(12.34)
      expect(gc.longitude).to eql(56.78)
      expect(gc.query).to eql("42 foo st, boston, ma")
      expect(gc.provider).to eql("nominatim")
    end

    it "returns existing record" do
      expect(Geocoder).to_not receive(:search)
      gc1 = Geocode.create({query: "42 foo st, boston, ma", provider: "nominatim", latitude: 42.12, longitude: 42.23})
      gc2 = Geocode.geocode_address("FOO ST", "42")
      expect(gc1). to eql(gc2)
    end

    it "returns record when location not found" do
      expect(Geocoder).to receive(:search).and_return([])
      gc = Geocode.geocode_address("FOO", "123")
      expect(gc.latitude).to eql(nil)
      expect(gc.longitude).to eql(nil)
    end
  end
end
