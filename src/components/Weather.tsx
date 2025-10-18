import React, { useState, useEffect } from "react";
import { gql } from "@apollo/client"
import { useLazyQuery, useMutation, useQuery } from "@apollo/client/react";
import "./Weather.css";

import { SAVE_USER_PREFERENCES, FETCH_USER_PREFERENCES } from "../graphql/weather";
import { useUserId } from "../hooks/useUserId";

// GraphQL Types
interface WeatherResponse {
  weather: {
    city: string;
    temperature: number;
    feelsLike: number;
    humidity: number;
    condition: string;
    cloudCover: number;
    uv: number;
    airQuality: number;
    recommendation: string;
  };
}

interface InputVariables {
  city: string;
  duration: number;
  pollenLevel: "None" | "Light" | "Mild" | "Severe";
  skinType: "I" | "II" | "III" | "IV" | "V" | "VI";
}

interface UserPreferences {
  uuid: string;
  city: string;
  duration: number;
  skinType: "I" | "II" | "III" | "IV" | "V" | "VI";
}

interface FetchUserPreferencesResponse {
  fetchUserPreferences: {
    uuid: string;
    latestRunPreference: {
      city: string;
      duration: number;
      skinType: string;
    } | null;
  };
}


interface FetchUserPreferencesVariables {
  userId: string;
}

// Weather Query
const GET_WEATHER = gql`
  query GetWeather($city: String!, $duration: Int!, $pollenLevel: String!, $skinType: String!) {
    weather(city: $city, duration: $duration, pollenLevel: $pollenLevel, skinType: $skinType) {
      city
      temperature
      feelsLike
      humidity
      condition
      cloudCover
      uv
      airQuality
      recommendation
    }
  }
`;

const Weather: React.FC = () => {
  // Form State
  const [city, setCity] = useState<string>("");
  const [duration, setDuration] = useState<number>(15);
  const [pollenLevel, setPollenLevel] = useState<"None" | "Light" | "Mild" | "Severe">("None");
  const [skinType, setSkinType] = useState<"I" | "II" | "III" | "IV" | "V" | "VI">("III");

  // User ID
  const userId = useUserId();
  const userUuid = localStorage.getItem("user_uuid") || crypto.randomUUID();
  localStorage.setItem("user_uuid", userUuid);

  // Fetch saved preferences
  const { data: savedPrefsData } = useQuery<
    FetchUserPreferencesResponse,
    FetchUserPreferencesVariables
  >(FETCH_USER_PREFERENCES, {
    variables: { userId: userUuid },
    skip: !userUuid,
  });


  // Prefill form with saved preferences
  useEffect(() => {
  const preferences = savedPrefsData?.fetchUserPreferences.latestRunPreference;
    if (preferences) {
      setCity(preferences.city);
      setDuration(preferences.duration);
      setSkinType(preferences.skinType as any);

      getWeather({ variables: { city, duration, pollenLevel, skinType } });
    }
  }, [savedPrefsData]);


  // Weather Query
  const [getWeather, { data: weatherData, loading: weatherLoading, error: weatherError }] =
    useLazyQuery<WeatherResponse, InputVariables>(GET_WEATHER);

  // Save preferences mutation
  const [savePrefs] = useMutation(SAVE_USER_PREFERENCES);

  const handleSubmit = async () => {
    if (!city || !duration || !pollenLevel || !skinType) {
      alert("Please fill out all fields!");
      return;
    }

    // Save preferences
    await savePrefs({
      variables: { input: { userUuid, city, duration, skinType } },
    });


    // Fetch weather
    getWeather({ variables: { city, duration, pollenLevel, skinType } });
  };

  return (
    <div className="weather">
      <div className="weather-container">
        <input
          type="text"
          placeholder="City"
          value={city}
          onChange={(e) => setCity(e.target.value)}
        />
        <input
          type="number"
          placeholder="Run duration"
          value={duration}
          onChange={(e) => setDuration(Number(e.target.value))}
          min={1}
          max={60}
        />

        <div className="pollen-buttons">
          {["None", "Light", "Mild", "Severe"].map((level) => (
            <button
              key={level}
              className={`pollen-btn ${pollenLevel === level ? "selected" : ""}`}
              onClick={() => setPollenLevel(level as any)}
            >
              {level}
            </button>
          ))}
        </div>

        <div className="skin-buttons">
          {["I", "II", "III", "IV", "V", "VI"].map((num) => (
            <button
              key={num}
              className={`skin-btn ${skinType === num ? "selected" : ""}`}
              onClick={() => setSkinType(num as any)}
            >
              {num}
            </button>
          ))}
        </div>

        <button className="submit-btn" onClick={handleSubmit}>
          Submit
        </button>
      </div>

      <div className="weather-results">
        {weatherLoading && <p>Loading...</p>}
        {weatherError && <p>Error: {weatherError.message}</p>}
        {weatherData && (
          <>
            <h2>{weatherData.weather.city}</h2>
            <p>Condition: {weatherData.weather.condition}</p>
            <p>Temp: {weatherData.weather.temperature}°C</p>
            <p>Feels like: {weatherData.weather.feelsLike}°C</p>
            <p>Humidity: {weatherData.weather.humidity}%</p>
            <p>Cloud Cover: {weatherData.weather.cloudCover}%</p>
            <p>UV Index: {weatherData.weather.uv}</p>
            <p>Air Quality: {weatherData.weather.airQuality}</p>
            <p>Recommendation: {weatherData.weather.recommendation}</p>
          </>
        )}
      </div>
    </div>
  );
};

export default Weather;