"use client";
import { Weather } from "../models";
import { WeatherIcon, WindyIcon, HeavyRainIcon } from "./weather-icon";

export function WeatherCard({
  weather,
  date,
}: {
  weather: Weather | null;
  date: string;
}) {
  if (!weather) {
    return <></>;
  }
  return (
    <tr key={weather.id} className="divide-x divide-gray-200">
      <td className="whitespace-nowrap py-4 pl-4 pr-4 text-sm font-medium text-gray-900 sm:pl-0">
        {date}
      </td>
      <td className="whitespace-nowrap p-4 text-sm text-gray-500 flex flex-row items-center space-x-4">
        <WeatherIcon weather={weather} size={32} />
        <span>{weather.name}</span>
      </td>
      <td className="whitespace-nowrap p-4 text-sm text-gray-500">
        <span className="flex flex-row items-center">
          <span className="font-bold text-lg">{weather.high}&deg;</span>
          <span>/{weather.low}&deg;</span>
        </span>
      </td>
      <td className="whitespace-nowrap p-4 text-sm text-gray-500">
        <span className="flex flex-row items-center space-x-2">
          <HeavyRainIcon hex={"#4169E1"} size={24} />
          <span>{weather.rain}%</span>
        </span>
      </td>
      <td className="whitespace-nowrap py-4 pl-4 pr-4 text-sm text-gray-500 sm:pr-0">
        <span className="flex flex-row items-center space-x-2">
          <WindyIcon hex={"#778899"} size={24} />
          <span>
            {weather.direction} {weather.wind} mph
          </span>
        </span>
      </td>
    </tr>
  );
}
