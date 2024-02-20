import { weather } from "../data";
import { WeatherCard } from ".";
import { getWeather } from "../models/weather";
import { numberToString } from "../utils";

export async function WeatherForecast({ days }: { days: number }) {
  const forecast = getWeather({ weather, days });
  const day = numberToString(days);
  return (
    <div className="my-16 space-y-16">
      <div className="flex flex-col">
        <p className="text-white text-xl pb-2">{day} day weather report</p>
        <p className="text-xs italic">
          A day is removed from the beginning and added to the end of the
          forecase with each passing block. 1 day is equal to 1 block of time.
        </p>
      </div>
      <div className="grid grid-cols-7 gap-2">
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
