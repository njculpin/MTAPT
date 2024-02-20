import { weather } from "../data";
import { WeatherCard } from ".";
import { getWeather } from "../models/weather";
import { numberToString } from "../utils";

export async function WeatherForecast({ days }: { days: number }) {
  const forecast = getWeather({ weather, days });
  const day = numberToString(days);
  return (
    <div className="my-16 space-y-16">
      <p className="text-white text-xl pb-2">{day} day weather report</p>
      <div className="grid grid-cols-7 gap-2">
        {forecast.map(function (weather, wIdx: number) {
          return (
            <div key={wIdx}>
              <WeatherCard weather={weather} />
            </div>
          );
        })}
      </div>
    </div>
  );
}
