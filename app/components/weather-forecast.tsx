import { weather } from "../data";
import { getWeather } from "../models/weather";
import { WeatherCard } from "./weather-card";

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
              <thead>
                <tr className="divide-x divide-gray-200">
                  <th
                    scope="col"
                    className="py-3.5 pl-4 pr-4 text-left text-sm font-semibold text-gray-900 sm:pl-0"
                  >
                    Date
                  </th>
                  <th
                    scope="col"
                    className="px-4 py-3.5 text-left text-sm font-semibold text-gray-900"
                  >
                    Condition
                  </th>
                  <th
                    scope="col"
                    className="px-4 py-3.5 text-left text-sm font-semibold text-gray-900"
                  >
                    Temperature
                  </th>
                  <th
                    scope="col"
                    className="px-4 py-3.5 text-left text-sm font-semibold text-gray-900"
                  >
                    Percipitation
                  </th>
                  <th
                    scope="col"
                    className="py-3.5 pl-4 pr-4 text-left text-sm font-semibold text-gray-900 sm:pr-0"
                  >
                    Wind
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200 bg-white">
                {forecast.map((weather, idx) => (
                  <WeatherCard key={idx} weather={weather} date={dates[idx]} />
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
