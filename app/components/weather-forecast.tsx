import { weather } from "../data";
import { WeatherCard } from ".";
import { getWeather } from "../models/weather";

export async function WeatherForecast({ days }: { days: number }) {
  const forecast = getWeather({ weather, days });
  return (
    <div className="grid grid-cols-5 gap-2">
      {forecast.map(function (weather, wIdx: number) {
        return (
          <div key={wIdx}>
            <WeatherCard weather={weather} />
          </div>
        );
      })}
    </div>
  );
}
