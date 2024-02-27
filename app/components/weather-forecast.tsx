import { weather } from "../data";
import { getWeather } from "../models/weather";
import { WeatherIcon, WindyIcon, HeavyRainIcon } from "./weather-icon";

export async function WeatherForecast({ days }: { days: number }) {
  const forecast = getWeather({ weather, days });
  const startDate = new Date();
  const dates = GetDates(startDate, 7);
  return (
    <div className="my-16 space-y-4">
      <div className="flex justify-between">
        <p className="text-black text-xl pb-2">Weather</p>
      </div>
      <div className="mt-8 flow-root">
        <div className="-mx-4 -my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
          <div className="inline-block min-w-full py-2 align-middle sm:px-6 lg:px-8">
            <table className="min-w-full divide-y divide-gray-300">
              <tbody className="divide-y divide-gray-200 bg-white">
                {forecast.map((cast, idx) => (
                  <tr key={cast.id} className="divide-x divide-gray-200">
                    <td className="whitespace-nowrap py-4 pl-4 pr-4 text-sm font-medium text-gray-900 sm:pl-0">
                      {dates[idx]}
                    </td>
                    <td className="whitespace-nowrap p-4 text-sm text-gray-500 flex flex-row items-center space-x-4">
                      <WeatherIcon weather={cast} size={32} />
                      <span>{cast.name}</span>
                    </td>
                    <td className="whitespace-nowrap p-4 text-sm text-gray-500">
                      <span className="flex flex-row items-center">
                        <span className="font-bold text-lg">
                          {cast.high}&deg;
                        </span>
                        <span>/{cast.low}&deg;</span>
                      </span>
                    </td>
                    <td className="whitespace-nowrap p-4 text-sm text-gray-500">
                      <span className="flex flex-row items-center space-x-2">
                        <HeavyRainIcon hex={"#4169E1"} size={24} />
                        <span>{cast.rain}%</span>
                      </span>
                    </td>
                    <td className="whitespace-nowrap py-4 pl-4 pr-4 text-sm text-gray-500 sm:pr-0">
                      <span className="flex flex-row items-center space-x-2">
                        <WindyIcon hex={"#778899"} size={24} />
                        <span>
                          {cast.direction} {cast.wind} mph
                        </span>
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}

function GetDates(startDate: Date, daysToAdd: number) {
  const weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  var dates = [];
  for (var i = 0; i <= daysToAdd; i++) {
    var currentDate = new Date();
    currentDate.setDate(startDate.getDate() + i);
    dates.push(
      weekdays[currentDate.getDay()] +
        " " +
        `${currentDate.getDate()}`.padStart(2, "0")
    );
  }
  return dates;
}
