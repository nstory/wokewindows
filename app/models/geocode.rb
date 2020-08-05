class Geocode < ApplicationRecord
  MIN_LATITUDE = 42.227654
  MIN_LONGITUDE = -71.19126
  MAX_LATITUDE = 42.396977
  MAX_LONGITUDE = -70.804488

  def self.geocode_intersection(street, xstreet)
    return nil if !street
    return nil if !xstreet
    streets = [street, xstreet].sort.map(&:downcase)
    query = "#{streets[0]} and #{streets[1]}, boston, massachusetts"
    search(query, "geocoder_ca") do
      Geocoder.search(query, lookup: :geocoder_ca)
    end
  end

  def self.geocode_address(street, number)
    return nil if !street
    return nil if !number
    query = "#{number.downcase} #{street.downcase}, boston, massachusetts"
    search(query, "nominatim") do
      sleep(1) # rate limit
      Geocoder.search(query, lookup: :nominatim, params: {countrycodes: "us"})
    end
  end

  def self.lat_long_in_boston?(lat, long)
    lat >= Geocode::MIN_LATITUDE && lat <= Geocode::MAX_LATITUDE && long >= Geocode::MIN_LONGITUDE && long <= Geocode::MAX_LONGITUDE
  end

  private
  def self.search(query, provider)
    # if this is cached, use the cached value
    gc = Geocode.find_by(query: query, provider: provider)
    return gc if gc

    # otherwise run the query
    r = yield(query, provider).first

    # only save results in Boston's bounding box
    latitude = nil
    longitude = nil
    if r && lat_long_in_boston?(r.latitude, r.longitude)
      latitude = r.latitude
      longitude = r.longitude
    end

    # and cache the result
    Geocode.create(
      query: query,
      provider: provider,
      latitude: latitude,
      longitude: longitude
    )
  end
end
