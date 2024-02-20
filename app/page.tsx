import { getWeather } from "./models";
import { weather, characters, equipment } from "./data";
import { WeatherCard, CharacterCard, EquipmentCard } from "./components";
import { numberToString } from "./utils";

export default function Home() {
  const days = 5;
  const weathers = getWeather({ weather, days });
  const day = numberToString(days);
  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24">
      <div className="max-w-5xl w-full justify-center font-mono">
        <div className="my-16 space-y-4">
          <h1 className="text-white text-6xl">Mt Aptos</h1>
          <p className="text-xl">
            Welcome to Base Camp{" "}
            <span className="text-purple-600">Cafeteria.</span>
          </p>
        </div>
        <div className="my-16 space-y-6">
          <div className="space-y-4">
            <p className="text-white text-xl">
              How many days will you attempt?
            </p>
            <p className="text-white text-md italic">
              1 day is equal to 1 block.
            </p>
          </div>

          <div>
            <div className="mt-2">
              <input
                type="number"
                name="days"
                id="days"
                style={{ fontSize: "32px" }}
                className="block w-full rounded-md border-0 py-1.5 bg-black text-white shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6 p-4"
                defaultValue={"0"}
                min={1}
              />
            </div>
          </div>
        </div>
        <div className="my-16 space-y-16">
          <p className="text-white text-xl pb-2">
            Here is the latest {day} day weather report
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
        <div className="my-16 space-y-6">
          <p className="text-white text-xl pb-2">
            Select your team for the trip
          </p>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {characters.map(function (item: CharacterAttributes) {
              return (
                <div key={item.name}>
                  <CharacterCard character={item} />
                </div>
              );
            })}
          </div>
        </div>
        <div className="my-16 space-y-6">
          <p className="text-white text-xl pb-2">Select Gear and Equipment</p>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            {equipment.map(function (item) {
              return (
                <div key={item.name}>
                  <EquipmentCard equipment={item} />
                </div>
              );
            })}
          </div>
        </div>
        <div className="my-16 flex justify-between items-center p-8 border">
          <div>
            <p className="text-white text-3xl">Ready to go?</p>
          </div>
          <button
            type="button"
            className="rounded-md bg-white/10 px-3.5 py-2.5 text-4xl font-semibold text-white shadow-sm hover:bg-white/20"
          >
            Depart
          </button>
        </div>
      </div>
    </main>
  );
}
