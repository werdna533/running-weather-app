module Types
  class WeatherType < Types::BaseObject
    field :city, String, null: false
    field :temperature, Float, null: false
    field :feels_like, Float, null: false
    field :humidity, Integer, null: false
    field :condition, String, null: false
    field :cloud_cover, Integer, null: false
    field :uv, Float, null: false
    field :air_quality, Integer, null: false
    field :recommendation, String, null: false
  end
end
