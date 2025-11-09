class WeatherFetcher
  include HTTParty

  def initialize(city)
    @city = city
  end

  def call
    weather_api_key = ENV["OPENWEATHER_API_KEY"]
    uv_api_key = ENV["OPENUV_API_KEY"]

    geo_response = HTTParty.get("http://api.openweathermap.org/geo/1.0/direct?q=#{@city}&appid=#{weather_api_key}")
    return { error: "Geocoding failed" } unless geo_response.success?

    geo_data = geo_response.parsed_response
    first_city = geo_data.first
    lat = first_city["lat"]
    lon = first_city["lon"]

    weather_response = HTTParty.get("https://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&appid=#{weather_api_key}&units=metric")
    return { error: "Weather fetch failed" } unless weather_response.success?
    aq_response = HTTParty.get("http://api.openweathermap.org/data/2.5/air_pollution?lat=#{lat}&lon=#{lon}&appid=#{weather_api_key}")
    return { error: "Air Quality fetch failed" } unless aq_response.success?
    uv_response = HTTParty.get("https://api.openuv.io/api/v1/uv?lat=#{lat}&lng=#{lon}", headers: { "x-access-token" => uv_api_key })
    return { error: "UV fetch failed" } unless uv_response.success?

    weather_data = weather_response.parsed_response
    aq_data = aq_response.parsed_response
    uv_data = uv_response.parsed_response

    puts "Geo data: #{geo_response.parsed_response.inspect}"
    puts "Weather data: #{weather_response.parsed_response.inspect}"
    puts "AQ data: #{aq_response.parsed_response.inspect}"
    puts "UV data: #{uv_response.parsed_response.inspect}"

    {
      city: weather_data["name"] || @city,
      temperature: weather_data["main"]["temp"] || 0.0,
      feels_like: weather_data["main"]["feels_like"] || 0.0,
      humidity: weather_data["main"]["humidity"] || 0,
      condition: weather_data["weather"][0]["description"] || "unknown",
      cloud_cover: weather_data["clouds"]["all"] || 0,
      uv: uv_data["result"]["uv"] || 0,
      air_quality: aq_data["list"][0]["main"]["aqi"] || 0
    }
  end
end
