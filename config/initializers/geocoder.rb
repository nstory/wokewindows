Geocoder.configure(
  http_headers: {"User-Agent" => ENV['GEOCODER_USER_AGENT']},
  timeout: 10,
  geocoder_ca: {
    api_key: ENV['GEOCODER_CA_API_KEY']
  }
)
