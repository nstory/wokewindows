Geocoder.configure(
  http_headers: { "User-Agent" => "Woke Windows Project n" + "s" + "tory" + "@wokewindows.org" },
  timeout: 10,
  geocoder_ca: {
    api_key: ENV['GEOCODER_CA_API_KEY']
  }
)
