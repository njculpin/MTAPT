import { weather } from "../data";
import { WeatherCard } from ".";
import { getWeather } from "../models/weather";

export async function WeatherForecast({ days }: { days: number }) {
  const forecast = getWeather({ weather, days });
  return (
    <div className="my-16 space-y-4">
      <div className="flex flex-col">
        <p className="text-black text-xl pb-2">Weather</p>
      </div>
      <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-7 gap-3">
        {forecast.map(function (weather, wIdx: number) {
          return (
            <div
              key={wIdx}
              className="flex flex-col justify-center items-center"
            >
              <WeatherCard weather={weather} />
              <p>Day {wIdx + 1}</p>
            </div>
          );
        })}
      </div>
    </div>
  );
}
