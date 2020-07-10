Geocoder.configure(
  http_headers: { "User-Agent" => "Woke Windows Project n" + "s" + "tory" + "@wokewindows.org" },
  geocoder_ca: {
    api_key: ENV['GEOCODER_CA_API_KEY']
  }
)
