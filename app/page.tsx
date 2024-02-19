import { getWeather } from "./models";
import { conditions, characters, equipment } from "./data";
import { WeatherCard } from "./components";
import { convertNumberToDays } from "./utils";

export default function Home() {
  const days = 5;
  const cost = 100;
  const weathers = getWeather({ conditions, days });
  const day = convertNumberToDays({ days });
  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24">
      <div className="max-w-5xl w-full justify-center font-mono">
        <div className="mt-4 space-y-4">
          <p className="text-xl">
            Welcome to Base Camp{" "}
            <span className="text-purple-600">Cafeteria.</span>
          </p>
          <h1 className="text-white text-6xl">Mt Aptos</h1>
          <p className="italic text-xs">
            Mt Aptos is a game about assembling a crew of explorers, equiping
            them and planning your expedition.
          </p>
        </div>
        <div className="mt-8 space-y-6">
          <p className="text-white text-xl pb-2">
            Here is your {day} day weather report
          </p>
          <div className="grid grid-cols-5 gap-2">
            {weathers.map(function (weather, wIdx: number) {
              return (
                <div key={wIdx}>
                  <WeatherCard weather={weather} />
                </div>
              );
            })}
          </div>
        </div>
        <div className="mt-8 space-y-6">
          <p className="text-white text-xl pb-2">
            Select your team for the trip
          </p>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            {characters.map(function (item: CharacterAttributes) {
              return (
                <div className="p-4 border border-gray-50" key={item.name}>
                  <div>
                    <div className="border-b pb-2">
                      <p>{item.name}</p>
                      <p>{item.profession}</p>
                    </div>
                    <div className="border-b py-2">
                      <p>{item.salary} APT per day</p>
                    </div>
                    <div className="pt-2">
                      {item.skills.map(function (skill: SkillAttributes) {
                        return <p key={skill.name}>{skill.name}</p>;
                      })}
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
        <div className="mt-8 space-y-6">
          <p className="text-white text-xl pb-2">Select Gear and Equipment</p>
          <div className="grid grid-cols-3 gap-4">
            {equipment.map(function (item) {
              return (
                <div className="p-4 border border-gray-50" key={item.name}>
                  <div>
                    <div>
                      <label
                        htmlFor="latitude"
                        className="block text-sm font-medium leading-6 text-white"
                      >
                        {item.name} - {item.cost} APT
                      </label>
                      <div className="mt-2">
                        <input
                          type="number"
                          name={item.name}
                          id={item.name}
                          className="block w-full rounded-md border-0 py-1.5 bg-black text-white shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6 p-4"
                          defaultValue={"0"}
                          min={0}
                        />
                      </div>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
        <div className="mt-8 space-y-6">
          <p className="text-white text-xl pb-2">
            Chart Course from 37.4427656,-122.1618973.
          </p>
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label
                htmlFor="latitude"
                className="block text-sm font-medium leading-6 text-white"
              >
                Latitude
              </label>
              <div className="mt-2">
                <input
                  type="number"
                  name="latitude"
                  id="latitude"
                  className="block w-full rounded-md border-0 py-1.5 bg-black text-white shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6 p-4"
                  defaultValue={"0"}
                />
              </div>
            </div>
            <div>
              <label
                htmlFor="longitude"
                className="block text-sm font-medium leading-6 text-white"
              >
                Longitude
              </label>
              <div className="mt-2">
                <input
                  type="number"
                  name="longitude"
                  id="longitude"
                  className="block w-full rounded-md border-0 py-1.5 bg-black text-white shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6 p-4"
                  defaultValue={"0"}
                />
              </div>
            </div>
          </div>
        </div>
        <div className="mt-8 flex justify-between items-center p-8 border">
          <div>
            <p className="text-white text-3xl">Ready to go?</p>
            <p className="text-white mt-4">
              {cost} APT for a {days} day journey
            </p>
            <p className="text-white mt-4">
              A single block is roughly 2 hours in real time. A single day on Mt
              Aptos is 1 block. A 5 day trip will take approximately 10 hours to
              complete.
            </p>
          </div>
          <button
            type="button"
            className="rounded-md bg-white/10 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-white/20"
          >
            Depart
          </button>
        </div>
      </div>
    </main>
  );
}
