class WeatherAnalyzer

    DANGEROUS_CONDITIONS = [
        /thunderstorm/i,
        /tornado/i,
        /freezing rain/i,
        /heavy snow/i,
        /heavy rain/i,
        /freezing rain/i,
        /volcanic ash/i,
        /dust/i,
        /smoke/i,
    ]

    CAUTION_CONDITIONS = [
        /light snow/i,
        /sleet/i,
        /drizzle/i,
        /rain/i,
        /mist/i,
        /haze/i,
        /fog/i,
        /squalls/i,
        /shower/i
    ]

  def initialize(weather_data, duration, pollen_level, skin_type)
    @weather = weather_data
    @duration = duration
    @pollen_level = pollen_level
    @skin = skin_type
  end

  def analyze

    feels_like_temp = @weather[:feels_like]

    if feels_like_temp < -39
        message = "DO NOT RUN: High risk of frostbite"
    elsif feels_like_temp < -27
        if @duration <= 30
            message = "Dress warmly and exercise caution during your chilly run."
        else
            message = "DO NOT RUN: High risk of frostbite in 30 mins of exposure"
        end
    elsif feels_like_temp < -9
        message = "Moderate risk of frostbite --> dress warmly"
    elsif feels_like_temp < 4
        message = "Dress warmly!"
    elsif feels_like_temp < 16
        message = "This is the ideal running temperature! Go wild!"
    elsif feels_like_temp < 25
        message = "Dress lightly and stay hydrated"
    elsif feels_like_temp < 30
        message = "Physical activity could lead to fatigue --> caution is advised; limit intensity"
    elsif feels_like_temp < 35
        if @duration <= 30
            message = "Exercise caution and take breaks during your run"
        else
            message = "DO NOT RUN: High risk of heat illness"
        end
    else 
        message = "DO NOT RUN: High risk of heat illness"
        
# 4 to 16 is ideal running temperature for most
# 26.7 - 32.2 caution, 
# 80-90 caution, 90 103 extreme caution, 103 danger
    end
=begin
    #Adjust the UV index value by accounting for cloud coverage
    cloud_cover = @weather[:cloud_cover]
    uv = @weather[:uv]

    if cloud_cover >= 0.2 && cloud_cover < 0.7
        @weather[:uv] = uv * 0.89
    elsif cloud_cover >= 0.7 && cloud_cover < 0.9
        @weather[:uv] = uv * 0.73
    elsif cloud_cover >= 0.9
        @weather[:uv] = uv * 0.31
    end
=end
    #Calculate time to burn in minutes
    uv = @weather[:uv]
    if uv > 0
        burn_time = case @skin
            when "I" then (200 * 2.5) / (3 * uv)
            when "II" then (200 * 3) / (3 * uv)
            when "III" then (200 * 4) / (3 * uv)
            when "IV" then (200 * 5) / (3 * uv)
            when "V" then (200 * 8) / (3 * uv)
            when "VI" then (200 * 15) / (3 * uv)
        end

        if burn_time <= @duration 
            message = message + "DO NOT RUN: High risk of sunburn. Max safe exposure: #{burn_time} minutes"
        end
    end 
    
    #Verify if air quality is safe
    air_quality = @weather[:air_quality]

    if air_quality > 3
        message = message + "DO NOT RUN: Poor air quality"
    elsif air_quality  > 2
        message = message + "Run with caution due to moderate air quality issues!"
    else
        message = message + "Air quality is ideal for running"
    end
    
    #Verify weather conditions
    condition = @weather[:condition]
    if DANGEROUS_CONDITIONS.any? { |c| condition.match(c) }
      message = message + "DO NOT RUN: Dangerous weather"
    elsif CAUTION_CONDITIONS.any? { |c| condition.match(c) }
      message = message + "Exercise caution: Conditions may be risky"
    else
      message = message + "Safe to run"
    end

    {
        city: @weather[:city],
        temperature: @weather[:temperature],
        feels_like: @weather[:feels_like],
        humidity: @weather[:humidity],
        condition: @weather[:condition],
        cloud_cover: @weather[:cloud_cover],
        uv: @weather[:uv],
        air_quality: @weather[:air_quality],
        recommendation: message
    }
  end
end
