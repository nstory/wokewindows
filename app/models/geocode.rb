class Geocode < ApplicationRecord
  def self.geocode_intersection(street, xstreet)
    return nil if !street
    return nil if !xstreet
    streets = [street, xstreet].sort.map(&:downcase)
    query = "#{streets[0]} and #{streets[1]}, boston, ma"
    search(query, "geocoder_ca") do
      sleep(1)
      Geocoder.search(query, lookup: :geocoder_ca)
    end
  end

  def self.geocode_address(street, number)
    return nil if !street
    return nil if !number
    query = "#{number.downcase} #{street.downcase}, boston, ma"
    search(query, "nominatim") do
      sleep(2)
      Geocoder.search(query, lookup: :nominatim, params: {countrycodes: "us"})
    end
  end

  private
  def self.search(query, provider)
    # if this is cached, use the cached value
    gc = Geocode.find_by(query: query, provider: provider)
    return gc if gc

    # otherwise run the query
    r = yield(query, provider).first

    # and cache the result
    Geocode.create(
      query: query,
      provider: provider,
      latitude: r ? r.latitude : nil,
      longitude: r ? r.longitude : nil,
    )
  end
end
