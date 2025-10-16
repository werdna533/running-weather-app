class WeatherController < ApplicationController
  def index

    weather_api_key = ENV["OPENWEATHER_API_KEY"]
    uv_api_key = ENV["OPENUV_API_KEY"]
    city = params[:city] || "Toronto"
    url = "http://api.openweathermap.org/geo/1.0/direct?q=#{city}&appid=#{weather_api_key}"

    coordinate_response = HTTParty.get(url)

    if coordinate_response.success?

      coordinate_data = coordinate_response.parsed_response

      first_city = coordinate_data.first
      latitude = first_city["lat"]
      longitude = first_city["lon"]

      weather_response = HTTParty.get("https://api.openweathermap.org/data/2.5/weather?lat=#{latitude}&lon=#{longitude}&appid=#{weather_api_key}&units=metric")
      aq_response = HTTParty.get("http://api.openweathermap.org/data/2.5/air_pollution?lat=#{latitude}&lon=#{longitude}&appid=#{weather_api_key}")

      uv_response = HTTParty.get("https://api.openuv.io/api/v1/uv?lat=#{latitude}&lng=#{longitude}", headers: {"x-access-token" => uv_api_key})
     
      if weather_response.success? 

        weather_data = weather_response.parsed_response
        aq_data = aq_response.parsed_response
        uv_data = uv_response.parsed_response

        render json: {
          city: weather_data["name"],
          temperature: weather_data["main"]["temp"],
          feels_like: weather_data["main"]["feels_like"],
          humidity: weather_data["main"]["humidity"],
          condition: weather_data["weather"][0]["description"],
          cloud_cover: weather_data["clouds"]["all"],
          uv: uv_data["result"]["uv"],
          air_quality: aq_data["list"][0]["main"]["aqi"]
        }
      else
        render json: {error: "unable to fetch weather data"}, status: :bad_request
      end 
    else
      render json: {error: "unable to use geocoding api"}, status: :bad_request
    end
  end
end
